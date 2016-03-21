after :option_types do
  class << self
    def set_options_for(product)
      OptionValue.find_each do |option|
        product.options << option if product.name.downcase.include? option.name.downcase
      end
      product.save
    end
  end

  Product.find_each do |product|
    set_options_for product if product.options.empty?
  end
end
