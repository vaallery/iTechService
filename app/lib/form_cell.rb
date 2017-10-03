module FormCell
  def self.included(base)
    base.class_eval do
      private

      include ModelCell
      include SimpleForm::ActionViewExtensions::FormHelper
      include ActionView::RecordIdentifier
      include FormHelper
      include ApplicationHelper
      # delegate :simple_form_for, to: :view_context
      property :persisted?, :to_partial_path
    end
  end

  private

  def page_title
    action_name = model.persisted? ? 'edit' : 'new'
    t ".title.#{action_name}"
  end

  def form(**options, &block)
    # options[:wrapper] = :horizontal_form
    options[:class] = "#{options[:class]} form-horizontal"
    simple_form_for contract, options, &block
  end

  def contract
    options.fetch :contract, model
  end

  def header_tag
    content_tag :div, class: 'page-header' do
      content_tag :h1, link_back_to_index + page_title
    end
  end
end
