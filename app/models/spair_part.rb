class SpairPart < ActiveRecord::Base
  belongs_to :repair_service
  belongs_to :item
  delegate :name, to: :item, allow_nil: true
  attr_accessible :quantity, :warranty_term, :repair_service_id, :item_id
  validates_presence_of :quantity, :repair_service, :item

  after_initialize do
    self.warranty_term ||= item.try(:warranty_term)
  end

end
