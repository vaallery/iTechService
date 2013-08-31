class Purchase < ActiveRecord::Base

  belongs_to :contractor, inverse_of: :purchases
  belongs_to :store, inverse_of: :purchases
  has_many :batches, inverse_of: :purchase
  has_many :products, through: :batches
  accepts_nested_attributes_for :batches, allow_destroy: true, reject_if: lambda { |a| a[:price].blank? or a[:quantity].blank? or a[:product].blank? }
  attr_accessible :status, :contractor, :store, :batches_attributes, :contractor_id, :store_id
  validates_presence_of :contractor, :store

  after_save :accord_stock_items

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
# TODO purchases search
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

  def set_deleted
    if self.status == 1
      errors.add :status, I18n.t('purchases.errors.deleting_posted')
    else
      update_attribute :status, 2
    end
  end

  private

  def accord_stock_items
    #if self.is_posted? and changed_attributes['status'] == 0
    #  self.batches.each do |batch|
    #    if batch.product.feature_accounting?
    #      batch.product.features.each do |feature|
    #        stock_item = StockItem.find_or_create_by_item_id_and_item_type_and_store_id(item_id: feature.id, item_type: feature.class.to_s, store_id: self.store_id)
    #
    #      end
    #
    #    end
    #
    #  end
    #end
  end

end
