after :option_types do
  class << self
    def set_options_for(product)
      # product.product_group.option_values.each do |option|
      OptionValue.find_each do |option|
        product.options << option if product.name.downcase.include? option.name.downcase
      end
      product.save!
    end
  end

  ProductGroup.find_each do |product_group|
    product_group.products.find_each do |product|
      if product.options.empty?
        set_options_for product
      end
    end
  end
end
