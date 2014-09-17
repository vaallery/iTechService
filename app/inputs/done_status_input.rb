class DoneStatusInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:div, class: 'done_status btn-group', 'data-toggle' => 'buttons-radio') do
      template.button_tag(template.icon_tag('check-empty'), 'data-value' => 0, class: "btn #{'active' if @builder.object.pending?}") +
      template.button_tag(template.icon_tag('check'), 'data-value' => 1, class: "btn #{'active' if @builder.object.done?}") +
      template.button_tag(template.icon_tag('check-minus'), 'data-value' => 2, class: "btn #{'active' if @builder.object.undone?}")
    end +
    @builder.hidden_field(attribute_name)
  end

end