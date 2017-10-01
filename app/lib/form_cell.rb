module FormCell
  def self.included(base)
    base.class_eval do
      include ModelCell
      include SimpleForm::ActionViewExtensions::FormHelper
      include ActionView::RecordIdentifier
      # delegate :simple_form_for, to: :view_context
      property :persisted?, :to_partial_path
    end
  end

  private

  def contract
    options.fetch :contract, model
  end
end