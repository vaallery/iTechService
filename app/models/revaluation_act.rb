class RevaluationAct < ActiveRecord::Base
  include Document

  belongs_to :price_type, inverse_of: :revaluation_acts
  has_many :revaluations, inverse_of: :revaluation_act, dependent: :destroy
  accepts_nested_attributes_for :revaluations, allow_destroy: true, reject_if: lambda { |a| a[:product_id].blank? or a[:price].blank? }
  #attr_accessor :product_ids
  attr_accessible :date, :price_type_id, :product_ids, :revaluations_attributes
  validates_presence_of :price_type, :date

  scope :posted, self.where(status: 1)
  scope :deleted, self.where(status: 2)

  after_initialize do
    self.status = 'new' if self.status.blank?
    self.date ||= Time.current
    self.price_type_id ||= PriceType.retail.id
  end

  def self.search(params)
    revaluation_acts = RevaluationAct.scoped

    unless (q = params[:q]).blank?
      revaluation_acts = revaluation_acts.where('id LIKE ?', "%#{q}%")
    end

    unless (start_date = params[:start_date]).blank?
      revaluation_acts = revaluation_acts.where('created_at >= ?', start_date)
    end

    unless (end_date = params[:end_date]).blank?
      revaluation_acts = revaluation_acts.where('created_at <= ?', end_date)
    end

    unless (price_type_id = params[:price_type_id]).blank?
      revaluation_acts = revaluation_acts.where(price_type_id: price_type_id)
    end

    revaluation_acts
  end

  def price_type_name
    price_type.present? ? price_type.name : ''
  end

  def post
    if is_new?
      transaction do
        cur_time = Time.current
        revaluations.each do |revaluation|
          ProductPrice.create(product_id: revaluation.product_id, price_type_id: self.price_type_id, date: cur_time, value: revaluation.price)
        end
        update_attribute :status, 1
      end
    end
  end

  def product_ids=(product_ids)
    product_ids.split(',').each do |product_id|
      self.revaluations.build product_id: product_id
    end
  end

end
