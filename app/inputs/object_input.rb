class ObjectInput < SimpleForm::Inputs::StringInput

  def input
    t = template
    f = @builder
    t.content_tag(:span, id: 'object_selector') do
      t.content_tag(:div, class: 'input-prepend') do
        t.link_to(t.icon_tag(:search), t.choose_products_path(form: 'order', association: '', is_product_only: true), class: 'btn', remote: true) +
        f.text_field(attribute_name)
      end
    end.html_safe
  end

end