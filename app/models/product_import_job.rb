class ProductImportJob < Struct.new(:params)

  TIME_FORMAT = "%Y.%m.%d %H:%M:%S"

  def name
    "Products import {#{params.inspect}}"
  end

  def perform
    if store.present?
      load_nomenclature if nomenclature_file.present?
      load_remnants if file.present?
      load_prices if prices_file.present?
      load_barcodes if barcodes_file.present?
    else
      import_log << ['error', 'Store is not defined!!!']
      ImportMailer.product_import_log(import_log, Time.current, :remnants).deliver
    end
  end

  def file
    @file ||= params[:file]
  end

  def prices_file
    @prices_file ||= params[:prices_file]
  end

  def barcodes_file
    @barcodes_file ||= params[:barcodes_file]
  end

  def nomenclature_file
    @nomenclature_file ||= params[:nomenclature_file]
  end

  def store
    @store ||= params[:store_id].present? ? Store.find(params[:store_id]) : nil
  end

  private

  def load_remnants
    import_time = Time.current
    import_log = []
    begin
      sheet = FileLoader.open_spreadsheet file
      import_log << ['info', "Import started at [#{import_time.strftime(TIME_FORMAT)}]. Store: #{store.name} [#{store.id}]"]
      product_group = parent_id = product = nil
      imported_item_ids = []
      (6..sheet.last_row-1).each do |i|
        row = sheet.row i
        import_log << ['inverse', "#{i} #{'-'*140}"]
        import_log << ['info', row]
        if (code = row[0][/\d+(?=.\|)/]).present?
          name = row[0][/(?<=\|\s).+(?=,)/]
          if row[10].blank?
            parent_id = product_group.id if product_group.present? and product_group.is_root?
            product_group = ProductGroup.create_with(name: name, parent_id: parent_id).find_or_create_by(code: code)
          elsif product_group.present? and name.present?
            if (product = Product.find_by_code(code)).present?
              import_log << ['info', "Existing product: [#{product.code}] #{product.name}"]
            else
              next_row = sheet.row i+1
              product_attributes = {code: code, name: name, product_group_id: product_group.id}
              if next_row[0].length > 3
                if next_row[0] =~ /,/
                  product_attributes.merge! product_category_id: ProductCategory.equipment_with_imei.id
                else
                  product_attributes.merge! product_category_id: ProductCategory.accessory_with_sn.id if product_group.is_accessory
                end
              end
              product = Product.new product_attributes
              if product.save
                import_log << ['success', 'New product: ' + product_attributes.inspect]
              else
                import_log << ['error', '!!! Unable to create product: ' + product.errors.full_messages.join('. ')]
              end
            end

            # Purchase Price
            purchase_price = product.prices.build price_type_id: PriceType.purchase.id, value: row[10], date: import_time
            if purchase_price.save
              import_log << ['success', 'New purchase Product Price: ' + purchase_price.value.to_s]
            else
              import_log << ['error', '!!! Unable to create purchase price: ' + purchase_price.errors.full_messages.join('. ')]
            end
            # Retail Price
            retail_price = product.prices.build price_type_id: PriceType.retail.id, value: row[11], date: import_time
            if retail_price.save
              import_log << ['success', 'New retail Product Price: ' + retail_price.value.to_s]
            else
              import_log << ['error', '!!! Unable to create retail price: ' + retail_price.errors.full_messages.join('. ')]
            end
          end
        elsif (quantity = row[5].to_i) > 0 and product.present?
          # Item
          if row[0].length > 3
            features = row[0].split ', '
            if (item = Item.search(q: features[0]).first).present?
              import_log << ['info', 'Item already present: ' + features.inspect]
            else
              if features.length == 2
                item = product.items.build features_attributes: {0 => {feature_type_id: FeatureType.serial_number.id, value: features[0]}, 1 => {feature_type_id: FeatureType.imei.id, value: features[1]}}
              else
                item = product.items.build features_attributes: {0 => {feature_type_id: FeatureType.serial_number.id, value: features[0]}}
              end
              if item.save
                import_log << ['success', 'New item: ' + features.inspect]
              else
                import_log << ['error', '!!! Unable to create item: ' + item.errors.full_messages.join('. ')]
              end
            end
          else
            item = product.items.first
            unless item.present?
              item = product.items.build
              if item.save
                import_log << ['success', 'New item: ' + item.inspect]
              else
                import_log << ['error', '!!! Unable to create item: ' + item.errors.full_messages.join('. ')]
              end
            end
          end

          # Store Items
          store_item_attributes = {store_id: store.id, quantity: quantity}
          if (store_item = (item.feature_accounting) ? item.store_items.first : item.store_items.in_store(store).first).present?
            # store_item.attributes = store_item_attributes
            if store_item.update_attributes store_item_attributes
              import_log << ['success', 'Update Store Item: ' + store_item.inspect]
            else
              import_log << ['error', '!!! Unable to update store item: ' + store_item.errors.full_messages.join('. ')]
            end
          else
            store_item = item.store_items.build store_item_attributes
            if store_item.save
              import_log << ['success', 'New Store Item: ' + store_item.inspect]
            else
              import_log << ['error', '!!! Unable to create item: ' + store_item.errors.full_messages.join('. ')]
            end
          end
          imported_item_ids << item.id
        end
      end
      import_log << ['inverse', '-'*160]
      import_log << ['success', "Imported #{imported_item_ids.count.to_s + ' item'.pluralize(imported_item_ids.count)}"]

      # Removing not imported items
      if imported_item_ids.present?
        import_log << ['info', 'Removing not imported items']
        items = Item.where 'id NOT IN (?)', imported_item_ids
        items.each do |item|
          item.remove_from_store store
          import_log << ['warning', "Item [#{item.code}] {#{item.name} | #{item.features.map(&:value).join(', ')}} set quantity to 0"]
        end
        import_log << ['warning', "Set zero quantity for #{items.count.to_s + ' item'.pluralize(items.count)}"]
      end
    rescue IOError
      import_log << ['error', '!!! Unable to load file ' + file.inspect]
    end
    import_log << ['info', "Import finished at [#{Time.current.strftime(TIME_FORMAT)}]"]
    ImportMailer.product_import_log(import_log, import_time, :remnants).deliver
  end

  def load_prices
    import_time = Time.current
    import_log = []
    begin
      sheet = FileLoader.open_spreadsheet prices_file
      import_log << ['info', "Import started at [#{import_time.strftime(TIME_FORMAT)}]. Store: #{store.name} [#{store.id}]"]
      batches_count = 0
      (9..sheet.last_row-1).each do |i|
        row = sheet.row i
        unless row[0].to_s[/\d+.\|/]
          sn = row[0].to_s[/[^,]+/]
          if (item = Item.search(q: sn).first).present?
            import_log << ['inverse', "#{i} #{'-'*140}"]
            import_log << ['info', row]
            price = row[4]
            batch = item.batches.build quantity: 1, price: price
            if batch.save
              batches_count = batches_count + 1
              import_log << ['info', 'Purchase price: ' + price.to_s]
              import_log << ['success', 'New Batch: ' + batch.inspect]
            else
              import_log << ['error', '!!! Unable to create batch: ' + batch.errors.full_messages.join('. ')]
            end
          end
        end
      end
      import_log << ['success', "Imported #{batches_count.to_s + ' batches'.pluralize(batches_count)}"]
    rescue IOError
      import_log << ['error', '!!! Unable to load file ' + prices_file.inspect]
    end
    import_log << ['info', "Import finished at [#{Time.current.strftime(TIME_FORMAT)}]"]
    ImportMailer.product_import_log(import_log, import_time, :prices).deliver
  end

  def load_barcodes
    import_time = Time.current
    import_log = []
    begin
      sheet = FileLoader.open_spreadsheet barcodes_file
      import_log << ['info', "Import started at [#{import_time.strftime(TIME_FORMAT)}]. Store: #{store.name} [#{store.id}]"]
      barcodes_count = 0
      (2..sheet.last_row).each do |i|
        row = sheet.row i
        barcode = row[0].to_i.to_s
        if barcode.length == 13 && barcode.start_with?('242')
          name = row[1]
          sn = row[2].to_s[/[^,]+/]
          if (item = Item.search(q: sn || name).first).present?
            import_log << ['inverse', "#{i} #{'-'*140}"]
            import_log << ['info', row]
            if item.update_attributes barcode_num: barcode
              import_log << ['success', 'New barcode: ' + item.inspect]
            else
              import_log << ['error', 'Unable to update barcode: ' + item.inspect]
            end
          else
            import_log << ['warning', 'Item not found: ' + (sn || name)]
          end
        end
      end
      import_log << ['success', "Imported #{barcodes_count.to_s + ' barcodes'.pluralize(barcodes_count)}"]
    rescue IOError
      import_log << ['error', '!!! Unable to load file ' + barcodes_file.inspect]
    end
    import_log << ['info', "Import finished at [#{Time.current.strftime(TIME_FORMAT)}]"]
    ImportMailer.product_import_log(import_log, import_time, :barcodes).deliver
  end

  def load_nomenclature
    import_time = Time.current
    import_log = []

    begin
      sheet = FileLoader.open_spreadsheet nomenclature_file
      import_log << ['info', "Import started at [#{import_time.strftime(TIME_FORMAT)}]"]
      product_group = nil
      (2..sheet.last_row-1).each do |i|
        row = sheet.row i
        import_log << ['inverse', "#{i} #{'-'*140}"]
        import_log << ['info', row]
        if (code = row[0].to_i.to_s).present?
          name = row[2]
          if row[1].blank?
            if (product_group = ProductGroup.find_by_code(code)).present?
              import_log << ['info', "Found product group: [#{product_group.code}] #{product_group.name}"]
            else
              import_log << ['error', "!!! Product group not found: [#{code}] #{name}"]
            end
          elsif product_group.present? && (product = Product.find_by_code(code)).present?
            if product.product_group_id != product_group.id
              if product.update_attributes(product_group_id: product_group.id)
                import_log << ['success', "Product group of #{product.name} [#{product.code}] changed to #{product_group.name} [#{product_group.code}]"]
              end
            end
          end
        end
      end
    rescue IOError
      import_log << ['error', '!!! Unable to load file ' + nomenclature_file.inspect]
    end
    import_log << ['info', "Import finished at [#{Time.current.strftime(TIME_FORMAT)}]"]
    ImportMailer.product_import_log(import_log, import_time, :nomenclature).deliver
  end

end
