class GiftCertificate < ActiveRecord::Base

  STATUSES = %w[available issued used]
  NOMINALS = %w[1500r 3000r 5000r 10000r 15000r]

  attr_accessible :number, :nominal, :status
  validates :number, presence: true
  before_validation do |cert|
    cert.status ||= 0
  end

  before_validation :validate_status

  def self.search(params)
    certificates = GiftCertificate.scoped

    if (search_q = params[:search_q]).present?
      certificates = certificates.where 'LOWER(number) LIKE ?', "%#{search_q.mb_chars.downcase.to_s}%"
    end
    certificates
  end

  def nominal_s
    NOMINALS[nominal]
  end

  def nominal_h
    I18n.t("gift_certificates.nominals.#{nominal_s}")
  end

  def status_s
    STATUSES[status]
  end

  def status_h
    I18n.t("gift_certificates.statuses.#{status_s}")
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

  private

  def validate_status
    if (old_status = changed_attributes['status'].present? ? changed_attributes['status'].to_i : nil).present?
      errors.add :base, I18n.t('gift_certificates.errors.not_available') if issued? and old_status != 0
      errors.add :base, I18n.t('gift_certificates.errors.not_issued') if used? and old_status != 1
      errors.add :base, I18n.t('gift_certificates.not_used') if available? and old_status != 2
    else
      errors.add :base, I18n.t('gift_certificates.errors.already_issued') if issued?
      errors.add :base, I18n.t('gift_certificates.errors.already_used') if used?
      errors.add :base, I18n.t('gift_certificates.already_available') if available?
    end
  end

end
