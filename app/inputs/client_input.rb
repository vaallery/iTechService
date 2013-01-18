class ClientInput < SimpleForm::Inputs::StringInput

  def input
    (template.content_tag(:div, id: 'client_input', class: 'input-prepend input-append',
                          'data-title' => @builder.object.class.human_attribute_name(:devices),
                          'data-content' => template.client_devices_list(@builder.object.client).to_s) do
      template.content_tag(:span, template.icon_tag(:search), class: 'add-on') +
      template.text_field_tag(:client_search, @builder.object.try(:client).try(:name_phone),
                              placeholder: 'name / phone number', autofocus: true) +
      @builder.hidden_field(attribute_name) +
      template.link_to(template.icon_tag(:plus), template.new_client_path, id: 'new_client_link', class: 'btn', remote: true) +
      template.link_to(template.icon_tag(:edit), @builder.object.client.present? ? template.edit_client_path(@builder.object.client) : '#',
          id: 'edit_client_link', class: 'btn', remote: true)
    end +
    template.content_tag(:ul, id: 'clients_autocomplete_list', class: 'dropdown-menu') do
      template.clients_autocomplete_list
    end).html_safe
  end

end