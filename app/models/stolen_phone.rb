class StolenPhone < ActiveRecord::Base

  attr_accessible :imei, :comment
  validates :imei, presence: true, length: {is: 15}

  def self.search params
    stolen_phones = StolenPhone.scoped
    unless (imei_q = params[:imei_q]).blank?
      stolen_phones = stolen_phones.where "LOWER(stolen_phones.imei) LIKE :q", q: "%#{imei_q}%"
    end
    stolen_phones
  end

end
