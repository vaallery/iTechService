class SubstitutePhone::Contract::Base < BaseContract
  model :substitute_phone
  properties :item, :item_id, :department, :department_id, :condition
  validates :item_id, :department_id, :condition, presence: true
end
