class ProductImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file, :store_id

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    time_format = "%Y.%m.%d %H:%M:%S"
    import_time = Time.current
    import_log << ['info', "Import started at [#{import_time.strftime(time_format)}]"]
    load_imported_products
    if imported_products.map(&:valid?).all?
      #imported_products.each &:save!
      imported_count = imported_products.count
      import_log << ['success', "Updated #{imported_count.to_s + " product".pluralize(imported_count)}"]
      import_log << ['info', "Import finished at [#{Time.current.strftime(time_format)}]"]
      true
    else
      imported_products.each_with_index do |product, index|
        product.errors.full_messages.each do |message|

          errors.add :base, "Row #{index+1} [code #{product.code}]: #{message}"
        end
      end
      false
    end
  end

  def load_imported_products
    sheet = FileLoader.open_spreadsheet file
    store = Store.find store_id
    products = []
    items = []
    store_items = []
    product_prices = []
    product_group = parent_id = product = nil
    (6..sheet.last_row-1).each do |i|
      row = sheet.row i
      import_log << ['inverse', "#{i} #{'-'*140}"]
      import_log << ['info', row]
      if (code = row[0][/\d+/]).present?
        name = row[0][/(?<=\|\s).+(?=,)/]
        if row[8].blank?
          parent_id = product_group.id if product_group.present? and product_group.is_root?
          product_group = ProductGroup.find_or_create_by_code(code: code, name: name, parent_id: parent_id)
        elsif product_group.present? and name.present?
          unless (prod = Product.find_by_code(code)).present?
            product = prod
            next_row = sheet.row i+1
            product_attributes = {code: code, name: name, product_group_id: product_group.id}
            if next_row[0].length > 3 and next_row[0] =~ /,/
              product_attributes.merge! product_category_id: ProductCategory.equipment_with_imei.try(:id)
            end
            product = Product.new product_attributes
            products << product
            import_log << ['success', 'New product: ' + product_attributes.inspect]
          end
        end
      elsif product.present? and (quantity = row[3].to_i) > 0
        import_log << ['info', 'Quantity: ' + quantity.inspect]
        # Item
        if row[0].length > 3
          features = row[0].split ', '
          import_log << ['info', 'Features: ' + features.inspect]
          if (item = Item.search(q: features[0]).first).present?
            import_log << ['info', 'Item already present: ' + features.inspect]
          else
            if features.length == 2
              item = product.items.build features_attributes: {0 => {feature_type_id: FeatureType.serial_number.id, value: features[0]}, 1 => {feature_type_id: FeatureType.imei.id, value: features[1]}}
            else
              item = product.items.build features_attributes: {0 => {feature_type_id: FeatureType.serial_number.id, value: features[0]}}
            end
            items << item
            import_log << ['success', 'New item: ' + features.inspect]
          end
        else
          unless (item = product.items.first).present?
            item = product.items.build
            items << item
            import_log << ['success', 'New item: ' + item.inspect]
          end
        end

        # Store Items
        store_item_attributes = {store_id: store.id, quantity: quantity}
        if (store_item = item.store_items.in_store(store).first).present?
          store_item.attributes = store_item_attributes
          import_log << ['success', 'Update store_item: ' + store_item.inspect]
        else
          store_item = item.store_items.build store_item_attributes
          import_log << ['success', 'New store_item: ' + store_item.inspect]
        end
        store_items << store_item

        # Prices
        #purchase_price = row[8]
        retail_price = row[9]
        product_price = product.prices.build price_type_id: PriceType.retail.id, value: retail_price, date: @import_time
        product_prices << product_price
        import_log << ['success', 'New retail product_price: ' + product_price.inspect]
      end
    end
    import_log << ['inverse', '-'*160]
    imported_products = products
    imported_items = items
    imported_store_items = store_items
    imported_product_prices = product_prices
  end

  def imported_products
    @imported_products ||= []
  end

  def imported_items
    @imported_items ||= []
  end

  def imported_store_items
    @imported_store_items ||= []
  end

  def imported_product_prices
    @imported_product_prices ||= []
  end

  def import_log
    @import_logs ||= []
  end

  def import_time
    @import_time
  end
  #
  #def imported_products
  #  @imported_products ||= load_imported_products[:products]
  #end
  #
  #def imported_items
  #  @imported_items ||= load_imported_products[:items]
  #end
  #
  #def imported_store_items
  #  @imported_store_items ||= load_imported_products[:store_items]
  #end
  #
  #def imported_product_prices
  #  @imported_product_prices ||= load_imported_products[:product_prices]
  #end

  #def load_imported
  #  sheet = open_spreadsheet
  #  products = []
  #  shop_cols = [4, 8]
  #  shops = []
  #  shop_cols.each do |col|
  #    if (shop = Shop.find_by_name sheet.cell(4, col)).present?
  #      shops << shop
  #    end
  #  end
  #  (6..sheet.last_row-1).each do |i|
  #    row = sheet.row i
  #    import_log << ['inverse', "#{i} #{'-'*140}"]
  #    import_log << ['info', row]
  #    unless (code_1c = row[0][/\d+/]).blank?
  #      if (product = Product.find_by_code_1c(code_1c)).present?
  #        new_attributes = {}
  #        new_attributes.merge! price: row[9].to_i unless product.is_fixed_price?
  #        stock_items_attributes = {}
  #        shops.each_with_index do |shop, s|
  #          if (stock_item = StockItem.where(product_id: product.id, shop_id: shop.id)).present?
  #            attributes = { id: stock_item.first.id, quantity: row[shop_cols[s]].to_i }
  #          else
  #            attributes = { quantity: row[shop_cols[s]].to_i, product_id: product.id, shop_id: shop.id }
  #          end
  #          stock_items_attributes.merge! s.to_s => attributes
  #        end
  #        new_attributes.merge! stock_items_attributes: stock_items_attributes
  #        product.attributes = new_attributes
  #        products << product
  #        import_log << ['success', 'New attributes: ' + new_attributes.inspect]
  #      else
  #        import_log << ['important', "Product with code [#{code_1c}] not found!"]
  #      end
  #    end
  #  end
  #  import_log << ['inverse', '-'*160]
  #  products
  #end

  private

  def open_spreadsheet
    filename = rename_uploaded_file file
    case File.extname(file.original_filename)
      when ".xls" then Roo::Excel.new(filename, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def rename_uploaded_file(file)
    begin
      new_file = File.join File.dirname(file.path), file.original_filename
      File.rename file.path, new_file
    rescue SystemCallError => error
      return error.to_s
    end
    return new_file
  end

end