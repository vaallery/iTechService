class ColorInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:span, class: 'input-append') do
      @builder.input_field(attribute_name) +
      template.tag(:span, class: 'add-on user_color_template')
    end.html_safe
  end

end