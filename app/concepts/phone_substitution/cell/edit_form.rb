module PhoneSubstitution::Cell
  class EditForm < BaseCell
    self.translation_path = 'substitute_phones.substitutions.edit'

    private

    include FormCell
    alias form_object model
    delegate :human_attribute_name, to: :SubstitutePhone
    property :substitute_phone, :condition_match, :condition_not_match?, :icloud_connected

    def url
      substitution_path(model)
    end

    def check_condition_note
      t 'substitute_phones.substitutions.edit.check_condition_note'
    end

    def check_icloud_note
      t 'substitute_phones.substitutions.edit.check_icloud_note'
    end

    def submit_label
      t 'substitute_phones.substitutions.edit.submit'
    end

    def attribute_presentation(attr_name)
      content_tag :div, class: 'control-group' do
        content_tag(:label, human_attribute_name(attr_name), class: 'control-label') +
        content_tag(:div, substitute_phone.send(attr_name), class: 'controls')
      end
    end

    def options_for_condition_match
      {
        t('simple_form.yes') => '1',
        t('simple_form.no') => '0'
      }
    end
  end
end
