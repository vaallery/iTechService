class ProductPrice < ActiveRecord::Base

  default_scope order('date desc')
  scope :newest_first, order('date desc')
  scope :with_type, lambda { |type| where(price_type_id: type.is_a?(PriceType) ? type.uid : type) }
  scope :purchase, where(price_type_id: PriceType.purchase.uid)
  scope :retail, where(price_type_id: PriceType.retail.uid)
  belongs_to :department, primary_key: :uid
  belongs_to :product, primary_key: :uid
  belongs_to :price_type, inverse_of: :product_prices, primary_key: :uid
  delegate :kind, :kind_s, :is_purchase?, :is_retail?, to: :price_type, allow_nil: true
  attr_accessible :value, :date, :product_id, :price_type_id, :department_id
  validates_presence_of :product, :price_type, :date, :value
  after_create UidCallbacks

  after_initialize do
    date ||= Time.current
    department_id ||= Department.current.uid
  end

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

end
