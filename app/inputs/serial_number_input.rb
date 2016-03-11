class SerialNumberInput < SimpleForm::Inputs::StringInput

  def input
    t = template
    t.content_tag(:div, class: 'input-append') do
      @builder.input_field(attribute_name, class: 'input-large', autocomplete: 'off') +
      t.link_to(t.icon_tag('search'), '#', id: 'service_job_serial_number_search', class: 'btn btn-info', title: I18n.t('service_jobs.seach_sales_btn'))
    end.html_safe
  end

end