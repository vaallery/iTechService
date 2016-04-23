class ColorInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    template.content_tag(:span, class: 'input-append color_input') do
      @builder.input_field(attribute_name, class: 'color_value') +
          template.tag(:span, class: 'add-on color_template')
    end.html_safe
  end

end
