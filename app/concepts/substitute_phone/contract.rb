class SubstitutePhone < ApplicationRecord
  class Contract < BaseForm
    model SubstitutePhone
    properties :item, :department, writeable: false
    properties :item_id, :department_id, :condition
    validates :item_id, :department_id, :condition, presence: true
  end
end
