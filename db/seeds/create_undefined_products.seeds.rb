after :product_groups_options do

  OptionValue.undefined.each do |option_value|
    ProductGroup.devices.includes(:option_values).where(option_values: {id: option_value.id}).find_each do |product_group|
      CreateProductsOfGroup.call product_group: product_group
    end
  end

end