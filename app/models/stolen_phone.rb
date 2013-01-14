class StolenPhone < ActiveRecord::Base

  attr_accessible :emei
  validates :emei, presence: true

  def self.search params
    stolen_phones = StolenPhone.scoped
    unless (emei_q = params[:emei_q]).blank?
      stolen_phones = stolen_phones.where "LOWER(stolen_phones.emei) LIKE :q", q: "%#{emei_q}%"
    end
    stolen_phones
  end

end
