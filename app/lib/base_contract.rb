class BaseContract < Reform::Form
  include Reform::Form::ActiveModel::ModelReflections
  include Reform::Form::ActiveRecord

  def to_partial_path
    'form'
  end
end
