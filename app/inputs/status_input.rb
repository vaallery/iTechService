class StatusInput < SimpleForm::Inputs::Base

  def input
    (@builder.hidden_field(:status) +
        template.content_tag(:span, class: 'btn-group') do
          template.content_tag(:button, id: 'status_select_button', class: 'btn dropdown-toggle',
                               'data-toggle' => 'dropdown') do
            template.content_tag(:span, id: 'status_value', class: 'pull-left') do
              @builder.object.status.blank? ? '-' : template.t("order.statuses.#{@builder.object.status}")
            end +
                template.content_tag(:span, nil, class: 'caret pull-right')
          end +
              template.content_tag(:ul, id: 'statuses_list', class: 'dropdown-menu') do
                Order::STATUSES.map do |status|
                  template.content_tag(:li, template.link_to(template.t("order.statuses.#{status}"), '#',
                                                             status: status))
                end.join.html_safe
              end
        end
    ).html_safe
  end

end