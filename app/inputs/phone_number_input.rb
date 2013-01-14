class PhoneNumberInput < SimpleForm::Inputs::StringInput

  def input
    template.content_tag(:div, class: 'input-append input-prepend') do
      template.content_tag(:span, template.icon_tag(:phone), class: 'add-on') +
      @builder.input_field(attribute_name, as: :tel, placeholder: template.t('phone_placeholder')) +
      template.content_tag(:span, '0', id: 'phone_length', class: 'add-on') +
      template.link_to(template.icon_tag(:ok), '#', id: 'check_phone_number', class: 'btn disabled')
    end.html_safe
  end

end