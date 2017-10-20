module Operation
  extend ActiveSupport::Concern

  included do
    include Trailblazer::Rails::Controller
  end

  def operation_model
    result['model']
  end

  def operation_message
    result['result.message']
  end

  def operation_success?
    result.success?
  end

  def operation_failed?
    !operation_success?
  end
end
