class SubstitutePhoneInput < SimpleForm::Inputs::Base
  delegate :content_tag, :text_field_tag, :check_box_tag, :link_to, :substitute_phones_stock_path, :glyph, :t, to: :template

  def input(wrapper_options = nil)
    content_tag( :div, class: 'substitute_phone input input-append') do
      @builder.hidden_field("#{attribute_name}_id", class: 'substitute_phone_id') +
      text_field_tag('substitute_phone', presentation, title: condition, class: 'form-control input-xlarge', readonly: true) +
      link_to(glyph('search'), substitute_phones_stock_path, remote: true, class: 'btn btn-info') +
      link_to(glyph('remove'), '#', data: {behaviour: 'remove-substitute_phone'}, class: 'btn btn-warning')
    end +

    content_tag(:p, t('service_jobs.form.substitution_note')) +
    content_tag(:div, class: 'checkbox') do
      content_tag(:label) do
        check_box_tag('service_job[substitute_phone_icloud_connected]') +
        content_tag(:span, t('service_jobs.form.icloud_connected'))
      end
    end +
    @builder.error(:substitute_phone_icloud_connected)
  end

  private

  def presentation
    @builder.object.substitute_phone&.presentation
  end

  def condition
    @builder.object.substitute_phone&.condition
  end
end