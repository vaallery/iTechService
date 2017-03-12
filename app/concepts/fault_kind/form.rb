class FaultKind < ApplicationRecord
  class Form < BaseForm
    model :fault_kind
    properties :name, :icon, :is_permanent
  end
end