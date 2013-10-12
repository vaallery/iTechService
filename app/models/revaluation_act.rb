class RevaluationAct < ActiveRecord::Base

  belongs_to :price_type, inverse_of: :revaluation_acts
  has_many :revaluations, inverse_of: :revaluation_act
  accepts_nested_attributes_for :revaluations, allow_destroy: true, reject_if: lambda { |a| a[:product_id].blank? or a[:price].blank? }
  attr_accessible :date, :price_type_id
  validates_presence_of :price_type_id, :date

  after_initialize do
    self.status = 'new' if self.status.blank?
    self.date ||= Time.current
  end

  STATUSES = {
      0 => 'new',
      1 => 'posted',
      2 => 'deleted'
  }

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

  def set_deleted
    if self.status == 1
      errors.add :status, I18n.t('revaluation_acts.errors.deleting_posted')
    else
      update_attribute :status, 2
    end
  end

end
