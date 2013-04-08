class GiftCertificate < ActiveRecord::Base

  STATUSES = %w[available issued used]
  NOMINALS = %w[1500r 3000r 5000r 10000r 15000r]

  has_many :history_records, as: :object, dependent: :destroy

  attr_accessible :number, :nominal, :status, :consumed, :consume
  attr_accessor :consume
  validates :number, presence: true, uniqueness: {case_sensitive: false}

  before_validation do |cert|
    cert.status ||= 0
  end

  before_validation :validate_consumption

  before_validation :validate_status, on: :update

  def self.search(params)
    certificates = GiftCertificate.scoped

    if (search_q = params[:search_q]).present?
      certificates = certificates.where 'LOWER(number) = ? OR id = ?', search_q.mb_chars.downcase.to_s, search_q.to_i
    end
    certificates
  end

  def nominal_s
    NOMINALS[nominal]
  end

  def nominal_h
    I18n.t("gift_certificates.nominals.#{nominal_s}")
  end

  def nominal_val
    NOMINALS[nominal][0..-1].to_i
  end

  def status_s
    STATUSES[status]
  end

  def status_h
    I18n.t("gift_certificates.statuses.#{status_s}")
  end

  def issue
    update_attributes status: 1
  end

  def refresh
    update_attributes status: 0, consumed: 0
  end

  def available?
    status == 0
  end

  def issued?
    status == 1
  end

  def used?
    status == 2
  end

  def consume=(amount)
    self.consumed = (self.consumed || 0) + amount
    self.status = 2 if self.consumed == nominal_val
  end

  def balance
    nominal_val - (consumed || 0)
  end

  def issued_at
    history_records.where(column_name: 'status', new_value: '1').last.try(:created_at)
  end

  def history_since_issue
    if issued?
      history_records.where('created_at >= ? AND column_name IN (?)', issued_at, %w[status consumed])
    else
      []
    end
  end

  private

  def validate_status
    if (old_status = changed_attributes['status'].present? ? changed_attributes['status'].to_i : nil).present?
      errors.add :base, I18n.t('gift_certificates.errors.not_available') if issued? and old_status != 0
      errors.add :base, I18n.t('gift_certificates.errors.not_issued') if used? and old_status != 1
      errors.add :base, I18n.t('gift_certificates.errors.not_used') if available? and old_status != 2
    end
  end

  def validate_consumption
    if changed_attributes['consumed'].present?
      if issued? or used?
        unless (consumed || 0) <= nominal_val
          errors.add :base, I18n.t('gift_certificates.errors.consumption_exceeded')
        end
      elsif consumed != 0
        errors.add :base, I18n.t('gift_certificates.errors.not_issued')
      end
    end
  end

end