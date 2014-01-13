module SupplyCategoriesHelper

  def nested_supply_categories(supply_categories)
    supply_categories.map do |supply_category, sub_supply_categories|
      content_tag :li, render(supply_category) + content_tag(:ul, nested_supply_categories(sub_supply_categories)), class: 'supply_category opened', id: "supply_category_#{supply_category.id}", title: supply_category.name, data: {supply_category_id: supply_category.id}
    end.join.html_safe
  end

end
