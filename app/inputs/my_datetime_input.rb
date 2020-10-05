class MyDatetimeInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    if options[:disabled]
      @builder.input_field(attribute_name, as: :string, disabled: true)
    else
      template.content_tag(:div, class: 'datetimepicker input-append') do
        @builder.input_field(attribute_name, as: :string) +
        template.content_tag(:span, template.content_tag(:i, nil, {data: {time_icon: 'icon-time', date_icon: 'icon-calendar'}}), class: 'add-on')
      end
    end
  end
end
