class SecurityCodeInput < SimpleForm::Inputs::StringInput

  def input
    template.content_tag(:div, class: 'input-append') do
      @builder.input_field(attribute_name, class: 'input-large') +
      template.link_to('None', '#', id: 'device_security_code_none', class: 'btn btn-warning', remote: true)
    end.html_safe
  end

end