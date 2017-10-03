class FaultKind::Contract::Base < BaseContract
  model :fault_kind
  properties :name, :icon, :is_permanent
end
