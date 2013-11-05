class Sale < ActiveRecord::Base

  belongs_to :user, inverse_of: :sales
  belongs_to :client, inverse_of: :sales
  belongs_to :store
  belongs_to :payment_type
  has_many :sale_items, inverse_of: :sale
  has_many :items, through: :sale_items
  accepts_nested_attributes_for :sale_items, allow_destroy: true, reject_if: lambda { |a| a[:quantity].blank? or a[:item_id].blank? }
  attr_accessible :date, :client_id, :user_id, :store_id, :payment_type_id, :sale_items_attributes
  validates_presence_of :user, :store, :payment_type, :date, :status
  before_validation :set_user
  after_initialize do
    self.user_id ||= User.try(:current).try(:id)
    self.date ||= Time.current
    self.status ||= 0
  end

  STATUSES = {
      0 => 'new',
      1 => 'posted',
      2 => 'deleted'
  }

  scope :sold_at, lambda { |period| where(date: period) }
  scope :posted, where(status: 1)
  scope :deleted, where(status: 2)

  def self.search(params)
    sales = Sale.scoped

    unless (start_date = params[:start_date]).blank?
      sales = sales.where('sold_at >= ?', start_date)
    end

    unless (end_date = params[:end_date]).blank?
      sales = sales.where('sold_at <= ?', end_date)
    end

    if (search = params[:search]).present?
      sales = sales.where 'id LIKE ?', "%#{search}%"
    end

    if (client_q = params[:client]).present?
      sales = sales.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
    end

    sales
  end

  def client_presentation
    client.present? ? client.presentation : '-'
  end

  def status_s
    STATUSES[status]
  end

  def is_new?
    status == 0
  end

  def is_posted?
    status == 1
  end

  def is_deleted?
    status == 2
  end

  def post
    if is_new?
      transaction do
        sale_items.each do |sale_item|
          item = sale_item.item
          if (store_item = item.store_item(store_id)).present? and item.available_quantity(self.store_id) >= sale_item.quantity
            store_item.dec sale_item.quantity
          else
            self.errors[:base] << t('sales.errors.out_of_stock')
          end
        end
        update_attribute :status, 1
      end
    end
  end

  def unpost
    #TODO unposting sale
  end

  def set_deleted
    if self.status == 1
      errors.add :status, I18n.t('sales.errors.deleting_posted')
    else
      update_attribute :status, 2
    end
  end

  def total_sum
    sale_items.sum :price
  end

  private

  def set_user
    self.user_id ||= User.try(:current).try(:id)
  end

end
