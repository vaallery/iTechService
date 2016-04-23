class ImeiInput < SimpleForm::Inputs::StringInput

  def input(wrapper_options = nil)
    t = template
    t.content_tag(:div, class: 'input-append') do
      @builder.input_field(attribute_name, class: 'input-large', autocomplete: 'off') +
      t.link_to(t.icon_tag('search'), '#', id: 'service_job_imei_search', class: 'btn btn-info', title: I18n.t('service_jobs.seach_sales_btn'))
    end.html_safe +
    t.tag(:br) +
    t.link_to(I18n.t('service_jobs.form.check_imei', default: 'Check IMEI'), '#', id: 'check_imei_link', target: '_blank')
  end

end