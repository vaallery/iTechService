class StoreProduct < ActiveRecord::Base

  belongs_to :store, primary_key: :uid
  belongs_to :product, primary_key: :uid
  attr_accessible :warning_quantity, :store_id, :product_id
  validates_presence_of :store
  validates_numericality_of :warning_quantity, only_integer: true, greater_than: 0, allow_nil: true
  validates_uniqueness_of :product_id, scope: :store_id
  after_create UidCallbacks

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

end
