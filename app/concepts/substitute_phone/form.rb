class SubstitutePhone < ApplicationRecord
  class Form < BaseForm
    properties :item, :item_id, :condition
    validates :item_id, :condition, presence: true
  end
end