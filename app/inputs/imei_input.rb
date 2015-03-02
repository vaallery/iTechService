class ImeiInput < SimpleForm::Inputs::StringInput

  def input
    t = template
    t.content_tag(:div, class: 'input-append') do
      @builder.input_field(attribute_name, class: 'input-large', autocomplete: 'off') +
      t.link_to(t.icon_tag('search'), '#', id: 'device_imei_search', class: 'btn btn-info', title: t.t('devices.seach_sales_btn'))
    end.html_safe +
    t.tag(:br) +
    t.link_to(I18n.t('devices.form.check_imei', default: 'Check IMEI'), '#', id: 'check_imei_link', target: '_blank')
  end

end