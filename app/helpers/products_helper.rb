module ProductsHelper

  #def nested_products(products)
  #  if products.present?
  #    products.map do |product, sub_products|
  #      product_li product, sub_products
  #    end.join.html_safe
  #  else
  #    nil
  #  end
  #end

  #def product_li(product, sub_products=nil)
  #  content_tag(:li, render(product) + content_tag(:ul, nested_products(sub_products)), class: 'product_item open', id: "product_#{product.id}", product_id: product.id, product_name: product.name, title: product.name)
  #end

  #def nested_products_list(products=nil, is_sub=false)
  #  products ||= Product.roots.goods.first.subtree.arrange
  #  ((products.any? and is_sub) ? content_tag(:li, nil, class: 'divider') : '').html_safe +
  #  products.map do |product, sub_products|
  #    ins_class = (sub_products.any?) ? 'icon-chevron' : 'icon-ok'
  #    list_class = 'unstyled hidden ' + ((sub_products.any?) ? 'full' : 'empty')
  #    content_tag(:li, link_to(product.name.html_safe + content_tag(:ins, nil, class: ins_class), '#', class: 'product_link') + content_tag(:ul, nested_products_list(sub_products, true), class: list_class), product_id: product.id, product_name: product.name, feature_types: "#{(product.feature_types.map{|ft|[ft.id.to_s, ft.name]}.to_s)}", class: 'product_item closed')
  #  end.join.html_safe
  #end

  #def nested_product_groups_list(product_groups=nil, is_sub=false)
  #  ((product_groups.any? and is_sub) ? content_tag(:li, nil, class: 'divider') : '').html_safe +
  #  product_groups.map do product_group, sub_product_groups|
  #    list_class = 'unstyled hidden '
  #    if sub_product_groups.any?
  #      ins_class = 'icon-chevron'
  #      list_class << 'full'
  #      sub_list = nested_product_groups_list(sub_product_groups, true)
  #    else
  #      sub_list = 'icon-ok'
  #      list_class = 'empty'
  #      sub_list = sub_product_groups.any? ? nested_product_groups_list(sub_product_groups, true)
  #    end
  #
  #    content_tag(:li, link_to(product_group.name.html_safe + content_tag(:ins, nil, class: ins_class), '#', class: 'product_link') + content_tag(:ul, sub_list, class: list_class), product_id: product_group.id, product_name: product_group.name, feature_types: "#{(product_group.feature_types.map { |ft| [ft.id.to_s, ft.name] }.to_s)}", class: 'product_item closed')
  #
  #  end.join.html_safe
  #end

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

end
