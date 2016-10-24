class FaultKind < ApplicationRecord
  class Form < ItechService::Form
    model FaultKind
    properties :name, :icon, :is_permanent
  end
end