class Purchase < ActiveRecord::Base

  belongs_to :contractor, inverse_of: :purchases
  belongs_to :store, inverse_of: :purchases
  has_many :batches, inverse_of: :purchase
  has_many :items, through: :batches
  accepts_nested_attributes_for :batches, allow_destroy: true, reject_if: lambda { |a| a[:price].blank? or a[:quantity].blank? or a[:item_id].blank? }
  attr_accessible :batches_attributes, :contractor_id, :store_id, :date
  validates_presence_of :contractor, :store
  validates_associated :batches

  after_initialize lambda { |purchase| purchase.status = 'new' if purchase.status.blank? }

  #before_save :update_stock_items_and_prices

  STATUSES = {
    0 => 'new',
    1 => 'posted',
    2 => 'deleted'
  }

  #scope :new, where(status: 0)
  scope :posted, where(status: 1)
  scope :deleted, where(status: 2)

  def self.search(params)
    purchases = Purchase.scoped

    unless (purchase_q = params[:purchase_q]).blank?
      purchases = purchases.where('id LIKE ?', "%#{purchase_q}%")
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

  def is_new?
    status == 0
  end

  def is_posted?
    status == 1
  end

  def is_deleted?
    status == 2
  end

  def status_s
    STATUSES[status]
  end

  def set_deleted
    if self.status == 1
      errors.add :status, I18n.t('purchases.errors.deleting_posted')
    else
      update_attribute :status, 2
    end
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
        cur_date = Date.current
        batches.each do |batch|
          item = batch.item
          if item.feature_accounting
            if (store_item = item.store_items.first_or_create).quantity > 0
              self.errors[:base] << t('purchases.errors.store_item_already_present')
            else
              store_item.update_attributes store_id: store_id, quantity: 1
            end
          else
            store_item = StoreItem.find_or_initialize_by_item_id_and_store_id item_id: item.id, store_id: self.store_id
            store_item.add batch.quantity
            #store_item.quantity = (store_item.quantity || 0) + batch.quantity
            #store_item.save!
          end
          store.price_types.each do |price_type|
            price = item.prices.find_or_initialize_by_price_type_id_and_date price_type_id: price_type.id, date: cur_date
            price.value = batch.price
            price.save!
          end
        end
        update_attribute :status, 1
      end
    end
  end

  def unpost
    if is_posted?
      transaction do
        cur_date = Purchase.created_at
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
