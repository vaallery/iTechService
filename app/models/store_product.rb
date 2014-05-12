class StoreProduct < ActiveRecord::Base

  belongs_to :store, primary_key: :uid
  belongs_to :product, primary_key: :uid
  attr_accessible :warning_quantity, :store_id, :product_id
  validates_presence_of :store
  validates_numericality_of :warning_quantity, only_integer: true, greater_than: 0, allow_nil: true
  validates_uniqueness_of :product_id, scope: :store_id
  after_create UidCallbacks

end
