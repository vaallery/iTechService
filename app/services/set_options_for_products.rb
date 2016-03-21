class SetOptionsForProducts

  def call
    ProductGroup.find_each do |product_group|
      product_group.products.find_each do |product|
        if product.options.empty?
          set_options_for product
        end
      end
    end
  end

  private

  def set_options_for(product)
    product.product_group.option_values.each do |option|
      product.options << option if product.name.downcase.include? option.name.downcase
    end
    product.save!
  end
end
