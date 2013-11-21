class MovementAct < ActiveRecord::Base
  include Document

  belongs_to :user
  belongs_to :store
  belongs_to :dst_store, class_name: 'Store'
  has_many :movement_items, dependent: :destroy, inverse_of: :movement_act
  accepts_nested_attributes_for :movement_items, allow_destroy: true, reject_if: lambda { |a| a[:item_id].blank? or a[:quantity].blank? }
  attr_accessible :date, :dst_store_id, :store_id, :movement_items_attributes
  validates_presence_of :date, :dst_store, :store, :status, :user
  validate :stores_must_be_different
  before_validation :set_user
  delegate :name, to: :store, prefix: true, allow_nil: true
  delegate :name, to: :dst_store, prefix: true, allow_nil: true

  scope :posted, self.where(status: 1)
  scope :deleted, self.where(status: 2)

  after_initialize do
    self.user_id ||= User.try(:current).try(:id)
    self.date ||= Time.current
    self.status ||= 0
  end

  def self.search(params)
    movement_acts = MovementAct.scoped

    unless (start_date = params[:start_date]).blank?
      movement_acts = movement_acts.where('date >= ?', start_date)
    end

    unless (end_date = params[:end_date]).blank?
      movement_acts = movement_acts.where('date <= ?', end_date)
    end

    unless (store_id = params[:store_id]).blank?
      movement_acts = movement_acts.where store_id: store_id
    end

    unless (dst_store_id = params[:dst_store_id]).blank?
      movement_acts = movement_acts.where dst_store_id: dst_store_id
    end

    if (q = params[:q]).present?
      movement_acts = movement_acts.where id: q
    end

    movement_acts
  end

  def post
    if is_new?
      transaction do
        movement_items.each do |movement_item|
          if movement_item.quantity_in_store(store) < movement_item.quantity
            errors[:base] << I18n.t('movement_acts.errors.insufficient', product: movement_item.name)
          else
            movement_item.store_item(store).move_to dst_store, movement_item.quantity
          end
        end
        update_attribute :status, 1
      end
    end
  end

  def unpost

  end

  private

  def stores_must_be_different
    if self.store_id == self.dst_store_id
      msg = I18n.t 'movement_acts.errors.stores_same'
      self.errors.add :store_id, msg
      self.errors.add :dst_store_id, msg
    end
  end

  def set_user
    self.user_id ||= User.try(:current).try(:id)
  end

end
