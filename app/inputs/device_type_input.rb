class DeviceTypeInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    template.content_tag(:span, id: 'device_type_selector') do
      @builder.hidden_field("#{attribute_name}_id") +
      template.content_tag(:div, class: 'input-append input-prepend') do
        template.content_tag(:div, class: 'btn-group') do
          template.link_to(template.icon_tag(:refresh), template.device_type_select_service_jobs_path, class: 'btn', remote: true) +
          template.content_tag(:button, id: 'device_type_select_button', class: 'btn dropdown-toggle', 'data-toggle' => 'dropdown') do
            template.content_tag(:span, id: 'device_type_name', class: 'pull-left') do
              @builder.object.device_type.blank? ? '-' : @builder.object.device_type.try(:full_name)
            end +
            template.content_tag(:span, nil, class: 'caret pull-right')
          end +
          template.content_tag(:ul, id: 'device_types_list', class: 'dropdown-menu') do
            template.make_device_types_list(template.root_device_types)
          end
        end
      end
    end.html_safe
  end

end