class ObjectKindInput < SimpleForm::Inputs::Base

  def input
    (@builder.hidden_field(:object_kind) +
    template.content_tag(:span, class: 'btn-group') do
      template.content_tag(:button, id: 'object_kind_select_button', class: 'btn dropdown-toggle',
                            'data-toggle' => 'dropdown') do
        template.content_tag(:span, id: 'object_kind_value', class: 'pull-left') do
          @builder.object.object_kind.blank? ? '-' : template.t("order.object_kinds.#{@builder.object.object_kind}")
        end +
        template.content_tag(:span, nil, class: 'caret pull-right')
      end +
      template.content_tag(:ul, id: 'object_kinds_list', class: 'dropdown-menu') do
        Order::OBJECT_KINDS.map do |object_kind|
          template.content_tag(:li, template.link_to(template.t("order.object_kinds.#{object_kind}"), '#',
                                object_kind: object_kind))
        end.join.html_safe
      end
    end
    ).html_safe
  end

end