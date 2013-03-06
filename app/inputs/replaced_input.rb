class ReplacedInput < SimpleForm::Inputs::BooleanInput

  def input
    (super +
    template.content_tag(:span, class: 'help-inline') do
      template.t('device_types.available_for_replacement').html_safe + ': ' +
      template.content_tag(:span, id: 'available_for_replacement') do
        @builder.object.device_type.try(:available_for_replacement) unless @builder.object.new_record?
      end
    end).html_safe
  end

end