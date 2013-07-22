class MyDatetimeInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:div, class: 'datetimepicker input-append') do
      @builder.input_field(attribute_name, as: :string) +
      template.content_tag(:span, template.tag(:i, 'data-time-icon' => 'icon-time', 'data-date-icon' => 'icon-calendar'), class: 'add-on')
    end
    #template.content_tag(:div, class: 'input-prepend') do
    #  template.content_tag(:span, template.glyph(:time), class: 'add-on') +
    #  @builder.input_field(attribute_name, as: :string, id: "device_#{attribute_name}_2i", name: "device[#{attribute_name}(2i)]")
    #end
  end

end