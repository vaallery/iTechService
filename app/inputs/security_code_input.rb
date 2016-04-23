class SecurityCodeInput < SimpleForm::Inputs::StringInput

  def input(wrapper_options = nil)
    template.content_tag(:div, class: 'input-append') do
      @builder.input_field(attribute_name, class: 'input-large') +
      template.link_to('None', '#', id: 'service_job_security_code_none', class: 'btn btn-warning')
    end.html_safe
  end

end