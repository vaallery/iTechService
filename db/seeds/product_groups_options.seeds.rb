after :product_options do

  class << self

    def find_undefined_option(product)
      product.options.each do |option|
        option.option_type.option_values.undefined.first
      end
    end

  end

  ProductGroup.find_each do |product_group|
    option_value_ids = []
    product_group.products.find_each do |product|
      option_value_ids += product.option_ids
      product.option_types.each do |option_type|
        undefined_option = option_type.option_values.undefined.first
        option_value_ids << undefined_option.id if undefined_option.present?
      end
    end
    option_value_ids.uniq!
    product_group.option_value_ids = option_value_ids
    product_group.save
  end
end
