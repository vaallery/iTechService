class FormCell < BaseCell
  include SimpleForm::ActionViewExtensions::FormHelper
  include ActionView::RecordIdentifier
  # delegate :simple_form_for, to: :view_context
end