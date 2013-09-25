class Sale < ActiveRecord::Base

  belongs_to :user, inverse_of: :sales
  belongs_to :client, inverse_of: :sales
  belongs_to :store
  belongs_to :payment_type
  has_many :sale_items, inverse_of: :sale
  has_many :items, through: :sale_items

  attr_accessible :sold_at, :client_id, :user_id, :store_id, :payment_type_id
  validates_presence_of :user, :store, :payment_type, :sold_at, :status
  before_validation :set_user
  after_initialize do
    self.user_id ||= User.try(:current).try(:id)
    self.sold_at ||= Time.current
    self.status ||= 0
  end

  STATUSES = {
      0 => 'new',
      1 => 'posted',
      2 => 'deleted'
  }

  scope :sold_at, lambda { |period| where(sold_at: period) }

  def self.search(params)
    sales = Sale.scoped

    if (search = params[:search]).present?
      sales = sales.where 'LOWER(sales.serial_number) = :s OR LOWER(sales.imei) = :s', s: "#{search.mb_chars.downcase.to_s}"
    end

    if (client_q = params[:client]).present?
      sales = sales.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
    end

    sales
  end

  def client_presentation
    client.present? ? client.presentation : '-'
  end

  def post
    #TODO posting sale
  end

  def unpost
    #TODO unposting sale
  end

  def total_sum

  end

  private

  def set_user
    self.user_id ||= User.try(:current).try(:id)
  end

end
