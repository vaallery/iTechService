class Purchase < ActiveRecord::Base
  include Document

  belongs_to :contractor, inverse_of: :purchases
  belongs_to :store, inverse_of: :purchases
  has_many :batches, inverse_of: :purchase, dependent: :destroy
  has_many :items, through: :batches
  accepts_nested_attributes_for :batches, allow_destroy: true, reject_if: lambda { |a| a[:price].blank? or a[:quantity].blank? or a[:item_id].blank? }
  attr_accessible :batches_attributes, :contractor_id, :store_id, :date
  validates_presence_of :contractor, :store
  validates_associated :batches

  scope :posted, self.where(status: 1)
  scope :deleted, self.where(status: 2)

  after_initialize do
    self.date ||= Time.current
    self.status ||= 0
  end

  #before_save :update_stock_items_and_prices

  def self.search(params)
    purchases = Purchase.scoped

    unless (purchase_q = params[:purchase_q]).blank?
      purchases = purchases.where(id: purchase_q)
    end

    unless (start_date = params[:start_date]).blank?
      purchases = purchases.where('created_at >= ?', start_date)
    end

    unless (end_date = params[:end_date]).blank?
      purchases = purchases.where('created_at <= ?', end_date)
    end

    unless (contractor_id = params[:contractor_id]).blank?
      purchases = purchases.where(contractor_id: contractor_id)
    end

    unless (store_id = params[:store_id]).blank?
      purchases = purchases.where(store_id: store_id)
    end

    purchases
  end

  def contractor_name
    contractor.try :name
  end

  def store_name
    store.try :name
  end

  def total_sum
    batches.sum { |batch| batch.sum }
  end

  def post
    if is_new?
      transaction do
        price_type = PriceType.purchase
        cur_date = Date.current
        batches.each do |batch|
          item = batch.item
          if item.feature_accounting
            if (store_item = item.store_items.first_or_create).quantity > 0
              self.errors[:base] << t('purchases.errors.store_item_already_present')
            else
              store_item.update_attributes store_id: store_id, quantity_in_store: 1
            end
          else
            store_item = StoreItem.find_or_initialize_by_item_id_and_store_id item_id: item.id, store_id: self.store_id
            store_item.add batch.quantity
          end
          item.prices.create price_type_id: price_type.id, date: cur_date, value: batch.price
        end
        update_attribute :status, 1
      end
    end
  end

  def unpost
    if is_posted?
      transaction do
        batches.each do |batch|
          item = batch.item
          item.store_items.in_store(self.store_id).each do |store_item|
            store_item.dec batch.quantity
          end
          #store.price_types.each do |price_type|
          #  price = item.prices.find_or_initialize_by_price_type_id_and_date price_type_id: price_type.id, date: cur_date
          #end
        end
        update status: 0
      end
    end
  end

  private

  def update_stock_items_and_prices
    if self.is_posted? and changed_attributes['status'] == 0

    end
  end

end
