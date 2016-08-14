class CreateProductsOfGroup
  include Interactor

  def call
    if product_group.is_childless?
      if product_group.option_values.count > 0
        option_value_combinations.each do |option_values|
          product_name = make_product_name option_values
          product_category_id = find_product_category_id product_name
          product = find_product option_values
          create_product product_name, product_category_id, option_values unless product.present?
        end
      end
    end
  end

  private

  def product_group
    @product_group ||= find_product_group
  end

  def find_product_group
    group = context.product_group
    group.is_a?(ProductGroup) ? group : ProductGroup.find(group)
  end

  def option_value_combinations
    @option_value_groups ||= get_option_value_combinations
  end

  def get_option_value_combinations
    option_values = product_group.option_values.ordered
    combinations ||= option_values.to_a.group_by(&:option_type_id).collect { |k,v| v.collect { |ov| ov} }
    combinations = combinations[0].product(*combinations[1..-1]) if combinations.length > 0
    combinations
  end

  def make_product_name(option_values)
    "#{product_group.name} #{option_values.map(&:name).join(' ')}"
  end

  def find_product_category_id(product_name)
    if product_name.include? 'Cellular'
      ProductCategory.find_by_name('Девайс с SIM').id
    else
      product_group.product_category_id
    end
  end

  def find_product(option_values)
    Product.find_by_group_and_options product_group.id, option_values.map(&:id)
  end

  def create_product(name, category_id, options)
    code = options.any?(&:undefined?) ? '?' : name.parameterize
    option_ids = options.map(&:id)
    Product.create! name: name, code: code, product_category_id: category_id,
                    product_group_id: product_group.id, option_ids: option_ids
  end
end