module SupplyCategoriesHelper

  def nested_supply_categories(supply_categories)
    supply_categories.map do |supply_category, sub_supply_categories|
      content_tag :li, render(supply_category) + content_tag(:ul, nested_supply_categories(sub_supply_categories)), class: 'supply_category opened', id: "supply_category_#{supply_category.id}", title: supply_category.name, data: {supply_category_id: supply_category.id}
    end.join.html_safe
  end

  def make_supply_categories_list(supply_categories)
    if supply_categories.present?
      supply_categories.map do |supply_category|
        content_tag :li, link_to("#{supply_category.name} #{glyph('chevron-right') if supply_category.has_children?}".html_safe, supply_category_path(supply_category), remote: true)
      end.join.html_safe
    end
  end

end
