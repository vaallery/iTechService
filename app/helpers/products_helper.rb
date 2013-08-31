module ProductsHelper

  def root_products
    DeviceType.roots
  end

  def products_root
    DeviceType.roots.first
  end

  def nested_products_list(products=products_root.descendants.scoped.arrange, is_sub=false)
    ((products.any? and is_sub) ? content_tag(:li, nil, class: 'divider') : '').html_safe +
    products.map do |product, sub_products|
      ins_class = (sub_products.any?) ? 'icon-chevron' : 'icon-ok'
      list_class = 'unstyled hidden ' + ((sub_products.any?) ? 'full' : 'empty')
      content_tag(:li, link_to(product.name.html_safe + content_tag(:ins, nil, class: ins_class), '#', class: 'product_link') + content_tag(:ul, nested_products_list(sub_products, true), class: list_class), product_id: product.id, product_name: product.full_name, feature_types: product.feature_types.map{|ft|[ft.id, ft.name]}, class: 'product closed')
    end.join.html_safe
  end

end
