class ClientInput < SimpleForm::Inputs::StringInput

  def input
    (
    template.content_tag(:div, id: 'client_input', class: 'input-prepend input-append') do
      template.content_tag(:span, template.icon_tag(:search), class: 'add-on') +
      template.text_field_tag(:client_search, @builder.object.try(:client).try(:name_phone),
                              placeholder: 'name / phone number', autofocus: true, autocomplete: 'off') +
      @builder.hidden_field(attribute_name) +
      template.link_to(template.icon_tag(:plus),
                       template.new_client_path, id: 'new_client_link', class: 'btn', remote: true) +
      template.link_to(template.icon_tag(:edit),
                       @builder.object.client.present? ? template.edit_client_path(@builder.object.client) : '#',
                       id: 'edit_client_link', class: 'btn', remote: true)
    end +
    template.content_tag(:ul, id: 'clients_autocomplete_list', class: 'dropdown-menu') do
      template.clients_autocomplete_list
    end +
    template.content_tag(:div, id: 'client_devices', class: 'popover fade right in') do
      template.content_tag(:div, nil, class: 'arrow') +
      template.content_tag(:div, class: 'popover-inner') do
        template.content_tag(:h3, class: 'popover-title') do
          template.t('devices.client_devices') +
          template.content_tag(:span, id: 'client_devices_resize_button', href: '#') do
            template.icon_tag('sort')
          end
        end +
        template.content_tag(:div, class: 'popover-content') do
          template.client_devices_list(@builder.object.client)
        end
      end
    end
    ).html_safe
  end

end