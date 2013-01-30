class SecurityCodeInput < SimpleForm::Inputs::StringInput

  def input
    template.content_tag(:div, class: 'input-append') do
      @builder.input_field(:security_code, class: 'input-large') +
      template.link_to('None', '#', id: 'device_security_code_none', class: 'btn btn-warning')
    end.html_safe
  end

end