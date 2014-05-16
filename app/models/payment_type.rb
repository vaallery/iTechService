class PaymentType < ActiveRecord::Base
  KINDS = %w[cash cashless mixed credit gift_card]
  scope :cash, where(kind: 'cash')
  scope :sachless, where(kind: 'cashless')
  attr_accessible :kind, :name
  validates_presence_of :name, :kind
  validates_inclusion_of :kind, in: KINDS
  after_create UidCallbacks

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

end
