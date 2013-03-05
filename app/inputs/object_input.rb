class ObjectInput < SimpleForm::Inputs::StringInput

  def input
    t = template
    f = @builder
    t.content_tag(:span, id: 'object_selector') do
      t.content_tag(:div, class: 'input-prepend') do
        t.content_tag(:div, class: 'btn-group') do
          t.link_to(t.icon_tag(:refresh), t.device_type_select_orders_path, class: 'btn', remote: true) +
          t.content_tag(:button, id: 'order_device_type_select_btn', class: 'btn dropdown-toggle',
              'data-toggle' => 'dropdown') do
            t.content_tag(:span, nil, class: 'caret')
          end +
          t.content_tag(:ul, id: 'device_types_list', class: 'dropdown-menu') do
            t.make_device_types_list(t.root_device_types, :order)
          end
        end +
        f.text_field(attribute_name)
      end
    end.html_safe
  end

end