class SetServiceJobsItems
  def call
    log.info "Task started at #{Time.now}"
    ServiceJob.where(item: nil).find_each do |service_job|
      if service_job.device_type.present?
        item = find_or_create_item service_job
        if item.present?
          service_job.update_column :item_id, item.id
        else
          log.warn "Item not found. ServiceJob-#{service_job.id}. DeviceType: #{service_job.device_type.full_name}"
        end
      else
        log.warn "No DeviceType. ServiceJob-#{service_job.id}."
      end
    end
    log.info "Task finished at #{Time.now}"
    log.close
  end

  def log
    @log ||= Logger.new('log/set_service_jobs_items.log')
  end

  private

  def find_or_create_item(service_job)
    find_item(service_job.serial_number) || create_item(service_job)
  end

  def find_item(serial_number)
    feature = Feature.serial_number.where('LOWER(value) = :q', q: serial_number.mb_chars.downcase.to_s).first
    if feature.present?
      feature.item
    else
      nil
    end
  end

  def create_item(service_job)
    product = find_product service_job.device_type
    if product.present?
      item = Item.new product: product
      features = {serial_number: service_job.serial_number}
      features.merge! imei: service_job.imei if service_job.has_imei?
      product.feature_types.each do |feature_type|
        item.features.build feature_type: feature_type, value: features[feature_type.kind.to_sym]
      end
      if item.valid?
        item.save!
      else
        log.warn "Item invalid. #{item.errors.full_messages.join(', ')}. Product: #{product.name} [#{product.id}]. Features: #{features}."
      end
      item
    else
      log.warn "Product not found. ServiceJob-#{service_job.id}. DeviceType: #{service_job.device_type.full_name} [#{service_job.device_type.id}]"
      nil
    end
  end

  def find_product(device_type)
    if device_type.product.present?
      device_type.product
    else
      product_group = find_product_group device_type.full_name
      if product_group.present?
        if product_group.option_values.any?
          options = find_options device_type, product_group
          find_product_by_group_and_options product_group.id, options.map(&:id)
        else
          find_product_by_device_type product_group, device_type
        end
      else
        log.warn "ProductGroup not found. DeviceType: #{device_type.full_name} [#{device_type.id}]."
        nil
      end
    end
  end

  def find_product_group(device_type_name)
    ProductGroup.devices.find_each do |product_group|
      return product_group if device_type_name == product_group.name || device_type_name.include?("#{product_group.name} ")
    end
    nil
  end

  def find_options(device_type, product_group)
    possible_options = product_group.option_values.to_a
    options = []
    device_types_for_options(device_type, product_group.name).each do |dt|
      possible_options.each do |option|
        options << option if option_match_device_type? option, dt
      end
    end
    options
  end

  def device_types_for_options(device_type, product_group_name)
    path = []
    device_type.path.to_a.reverse.each do |dt|
      if dt.full_name == product_group_name
        return path
      else
        path << dt
      end
    end
  end

  def option_match_device_type?(option, device_type)
    option_name = option.name.strip.mb_chars.downcase.to_s
    device_type_name = device_type.name.strip.mb_chars.downcase.to_s
    option_name == device_type_name || (option_name == '?' && device_type_name == 'none')
  end

  def find_product_by_device_type(product_group, device_type)
    product_group.products.each do |product|
      product_name = product.name
      product_name.gsub!(/#{product_group.name}/i, '')
      product_name.strip!
      device_types_for_options(device_type, product_group.name).each do |dt|
        product_name.gsub!(/#{dt.name}/i, '')
        product_name.strip!
      end
      return product if product_name.blank?
    end
    nil
  end

  def find_product_by_group_and_options(product_group_id, option_ids=nil)
    if product_group_id.present? && option_ids.present?
      Product.where(id: Product.includes(:options).where(product_group_id: product_group_id, product_options: {option_value_id: option_ids}).group('product_options.product_id').having('count(product_options.product_id) = ?', option_ids.length).count('products.id').keys.first).first
    elsif product_group_id.present? && option_ids.blank? && ProductGroup.find(product_group_id).option_values.none?
      (products = Product.where(product_group_id: product_group_id)).many? ? nil : products.first
    else
      nil
    end
  end
end
