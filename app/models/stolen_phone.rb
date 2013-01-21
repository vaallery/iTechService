class StolenPhone < ActiveRecord::Base

  attr_accessible :imei
  validates :imei, presence: true

  def self.search params
    stolen_phones = StolenPhone.scoped
    unless (imei_q = params[:imei_q]).blank?
      stolen_phones = stolen_phones.where "LOWER(stolen_phones.imei) LIKE :q", q: "%#{imei_q}%"
    end
    stolen_phones
  end

end
