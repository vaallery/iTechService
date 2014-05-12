class SparePart < ActiveRecord::Base
  belongs_to :repair_service, primary_key: :uid
  belongs_to :product, primary_key: :uid
  has_many :store_items, through: :product, primary_key: :uid
  delegate :name, :quantity_threshold, :comment, :quantity_in_store, :purchase_price, :remnant_s, :remnant_status, to: :product, allow_nil: true
  attr_accessible :quantity, :warranty_term, :repair_service_id, :product_id
  validates_presence_of :quantity, :product
  after_create UidCallbacks

  after_initialize do
    self.warranty_term ||= product.try(:warranty_term)
  end

end
