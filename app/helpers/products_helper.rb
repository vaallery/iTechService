module ProductsHelper

  def product_items(products)
    if products.any?
      products.map do |product|
        content_tag(:li, link_to(product.name, '#'))
      end.join.gsub('\n', '')
    else
      ''
    end
  end

  def product_select_list
    if ProductGroup.roots.goods.any?
      product_group = ProductGroup.roots.goods.first.subtree
      product_groups_tree_tag(product_group)
    else
      nil
    end
  end

  def remains_presentation(product, store)
    if product.present? and store.present?
      "#{product.available_quantity(store)} (#{product.available_quantity})"
    elsif
      "#{product.available_quantity}"
    else
      '-'
    end
  end

end
