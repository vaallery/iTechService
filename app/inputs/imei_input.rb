class ImeiInput < SimpleForm::Inputs::StringInput

  def input
    t = template
    t.content_tag(:div, class: 'input-append') do
      @builder.input_field(attribute_name, class: 'input-large') +
      t.link_to(t.icon_tag('search'), '#', id: 'device_imei_search', class: 'btn btn-info', remote: true,
      title: t.t('devices.seach_sales_btn'))
    end.html_safe
  end

end