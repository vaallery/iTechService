class Sale < ActiveRecord::Base
  include Document

  scope :sold_at, lambda { |period| where(date: period) }
  scope :posted, where(status: 1)
  scope :deleted, where(status: 2)

  belongs_to :user, inverse_of: :sales
  belongs_to :client, inverse_of: :sales
  belongs_to :store
  belongs_to :payment_type
  has_many :sale_items, inverse_of: :sale, dependent: :destroy
  has_many :items, through: :sale_items
  accepts_nested_attributes_for :sale_items, allow_destroy: true, reject_if: lambda { |a| a[:quantity].blank? or a[:item_id].blank? }

  delegate :name, :short_name, :full_name, :category, :category_s, to: :client, prefix: true, allow_nil: true

  attr_accessible :date, :client_id, :user_id, :store_id, :payment_type_id, :sale_items_attributes, :is_return
  validates_presence_of :user, :store, :date, :status
  validates_inclusion_of :status, in: Document::STATUSES.keys
  before_validation :set_user
  after_initialize do
    self.user_id ||= User.try(:current).try(:id)
    self.date ||= Time.current
    self.status ||= 0
    self.is_return ||= false
    self.store_id ||= Store.default.try(:id)
  end

  def self.search(params)
    sales = Sale.scoped

    unless (start_date = params[:start_date]).blank?
      sales = sales.where('sold_at >= ?', start_date)
    end

    unless (end_date = params[:end_date]).blank?
      sales = sales.where('sold_at <= ?', end_date)
    end

    if (search = params[:search]).present?
      sales = sales.where id: search
    end

    if (client_q = params[:client]).present?
      sales = sales.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
    end

    sales
  end

  def kind
    is_return ? 'return' : 'sale'
  end

  def client_presentation
    client.present? ? client.presentation : '-'
  end

  def post
    if is_valid_for_posting?
      transaction do
        sale_items.each do |sale_item|
          store_item = sale_item.store_item(store)
          store_item.feature_accounting ? store_item.destroy : store_item.dec(sale_item.quantity)
        end
        update_attribute :status, 1
      end
    else
      false
    end
  end

  def unpost
    #TODO unposting sale
  end

  def total_sum
    sale_items.sum :price
  end

  private

  def set_user
    self.user_id ||= User.try(:current).try(:id)
  end

  def is_valid_for_posting?
    is_valid = true
    if is_new?
      sale_items.each do |sale_item|
        store_item = sale_item.store_items.in_store(store).first
        if !store_item.present? or store_item.quantity < sale_item.quantity
          self.errors[:base] << t('sales.errors.out_of_stock')
          is_valid = false
        end
      end
    else
      errors[:base] << I18n.t('documents.errors.cannot_be_posted')
      is_valid = false
    end
    is_valid
  end

end
