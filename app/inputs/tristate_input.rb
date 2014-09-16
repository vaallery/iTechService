class TristateInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:div, class: 'tristate btn-group', 'data-toggle' => 'buttons-radio') do
      template.button_tag(template.icon_tag('check-empty'), 'data-value' => 'nil', class: "btn #{'active' if @builder.object.done.nil?}") +
      template.button_tag(template.icon_tag('check'), 'data-value' => 'true', class: "btn #{'active' if @builder.object.done}") +
      template.button_tag(template.icon_tag('check-minus'), 'data-value' => 'false', class: "btn #{'active' if @builder.object.done == false}")
    end +
    @builder.hidden_field(attribute_name)
  end

end