class BaseForm < Reform::Form
  include Reform::Form::ActiveModel::ModelReflections

  def to_partial_path
    'form'
  end
end