class ClientInput < SimpleForm::Inputs::StringInput

  def input
    (template.content_tag(:div, id: 'client_input', class: 'input-prepend input-append') do
      template.content_tag(:span, template.icon_tag(:search), class: 'add-on') +
      template.text_field_tag(:client_search, @builder.object.try(:client).try(:name_phone),
                              placeholder: 'name / phone number', autofocus: true) +
      @builder.hidden_field(:client_id) +
      template.link_to(template.icon_tag(:plus), template.new_client_path, id: 'new_client_link', class: 'btn', remote: true) +
      template.link_to(template.icon_tag(:edit), @builder.object.client.present? ? template.edit_client_path(@builder.object.client) : '#',
          id: 'edit_client_link', class: 'btn', remote: true)
    end +
    template.content_tag(:ul, id: 'clients_autocomplete_list', class: 'dropdown-menu') do
      template.clients_autocomplete_list
    end).html_safe
  end

  def input1
    template.content_tag(:div, class: 'input-prepend input-append') do
      template.content_tag(:span, template.icon_tag(:search), class: 'add-on') +
      template.autocomplete_field_tag(:client, @builder.object.try(:client).try(:name_phone), template.autocomplete_client_phone_number_devices_path,
                           id_element: '#device_client_id', placeholder: 'name / phone number', autofocus: true) +
      @builder.hidden_field(:client_id) +
      template.link_to(template.icon_tag(:plus), template.new_client_path, id: 'new_client_link', class: 'btn', remote: true) +
      template.link_to(template.icon_tag(:edit), @builder.object.client.present? ? template.edit_client_path(@builder.object.client) : '#',
          id: 'edit_client_link', class: 'btn', remote: true)
    end.html_safe
  end

end