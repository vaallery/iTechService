class Purchase < ActiveRecord::Base
  include Document

  scope :posted, -> { where(status: 1) }
  scope :deleted, -> { where(status: 2) }

  belongs_to :contractor, inverse_of: :purchases
  belongs_to :store, inverse_of: :purchases
  has_many :batches, inverse_of: :purchase, dependent: :destroy
  has_many :items, through: :batches
  accepts_nested_attributes_for :batches, allow_destroy: true, reject_if: lambda { |a| a[:price].blank? or a[:quantity].blank? or a[:item_id].blank? }

  attr_accessible :batches_attributes, :contractor_id, :store_id, :date, :comment, :skip_revaluation
  validates_presence_of :contractor, :store, :status, :date
  validates_inclusion_of :status, in: Document::STATUSES.keys
  validates_associated :batches

  after_initialize do
    self.date ||= DateTime.current
    self.status ||= 0
  end

  #before_save :update_stock_items_and_prices

  def self.search(params)
    purchases = Purchase.all

    unless (purchase_q = params[:purchase_q]).blank?
      purchases = purchases.where(id: purchase_q)
    end

    unless (start_date = params[:start_date]).blank?
      purchases = purchases.where('created_at >= ?', start_date.to_date)
    end

    unless (end_date = params[:end_date]).blank?
      purchases = purchases.where('created_at <= ?', end_date.to_date)
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
    batches.to_a.sum &:sum
  end

  def post
    if is_valid_for_posting?
      transaction do
        cur_date = Date.current

        batches.each do |batch|
          unless skip_revaluation?
            price_type = PriceType.purchase
            new_price = if batch.product.quantity_in_store > 0
                          (batch.product.remnants_cost + batch.sum) / (batch.product.quantity_in_store + batch.quantity)
                        else
                          batch.price
                        end
            batch.prices.create price_type_id: price_type.id, date: cur_date, value: new_price
          end

          if batch.feature_accounting
            batch.store_item.present? ? batch.store_item.update_attributes(store_id: store_id) : StoreItem.create(store_id: store_id, item_id: batch.item_id, quantity: 1)
          else
            batch.store_item(store).add batch.quantity
          end
        end

        update_attribute :status, 1
        update_attribute :date, DateTime.current
      end
    else
      false
    end
  end

  def unpost
  #  if is_posted?
  #    transaction do
  #      batches.each do |batch|
  #        item = batch.item
  #        item.store_items.in_store(self.store_id).each do |store_item|
  #          store_item.dec batch.quantity
  #        end
  #        #store.price_types.each do |price_type|
  #        #  price = item.prices.find_or_initialize_by price_type_id: price_type.id, date: cur_date
  #        #end
  #      end
  #      update_attribute :status, 0
  #      update_attribute :date, nil
  #    end
  #  end
  end

  def build_revaluation_act(product_ids=nil)
    RevaluationAct.new product_ids: product_ids
  end

  def build_movement_act(item_ids=[])
    movement_items_attributes = []
    dst_store_id = nil
    item_ids&.split(',').map do |item_id|
      if (batch = batches.where(item_id: item_id).first).present?
        movement_items_attributes << {item_id: item_id, quantity: batch.quantity}
        dst_store_id ||= batch.is_spare_part ? Store.spare_parts.first.try(:id) : Store.retail.first.try(:id)
      end
    end
    MovementAct.new store_id: store_id, dst_store_id: dst_store_id, movement_items_attributes: movement_items_attributes
  end

  private

  def update_stock_items_and_prices
    if self.is_posted? and changed_attributes['status'] == 0

    end
  end

  def is_valid_for_posting?
    is_valid = true
    if is_new?
      batches.each do |batch|
        if batch.feature_accounting
          if batch.store_item.present?
            errors[:base] << I18n.t('purchases.errors.store_item_already_present', product: batch.name)
            is_valid = false
          end
        end
      end
    else
      errors[:base] << I18n.t('documents.errors.cannot_be_posted')
      is_valid = false
    end
    is_valid
  end

end
