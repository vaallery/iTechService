class SubstitutePhone::Contract::Base < BaseContract
  model :substitute_phone
  properties :item, :department, writeable: false
  properties :item_id, :department_id, :condition, :archived
  validates :item_id, :department_id, :condition, presence: true
end
