class SubstitutePhone < ApplicationRecord
  class Contract < BaseForm
    model SubstitutePhone
    properties :item, :item_id, :condition
    validates :item_id, :condition, presence: true
  end
end