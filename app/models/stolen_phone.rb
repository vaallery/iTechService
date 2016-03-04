class StolenPhone < ActiveRecord::Base
  belongs_to :client
  has_many :comments, as: :commentable, dependent: :destroy
  attr_accessor :comment
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }
  delegate :presentation, to: :client, allow_nil: true, prefix: true
  attr_accessible :imei, :serial_number, :client_id, :client_comment, :comment, :comments_attributes
  validates :imei, presence: true, length: {is: 15}
  validates :serial_number, :client, presence: true
  validates_associated :comments

  def self.search params
    stolen_phones = StolenPhone.all
    unless (imei_q = params[:imei_q]).blank?
      stolen_phones = stolen_phones.where 'stolen_phones.imei LIKE :q', q: "%#{imei_q}%"
    end
    unless (serial_number_q = params[:serial_number_q]).blank?
      stolen_phones = stolen_phones.where 'stolen_phones.serial_number LIKE :q', q: "%#{serial_number_q}%"
    end
    unless (client_q = params[:client_q]).blank?
      stolen_phones = stolen_phones.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
    end
    stolen_phones
  end

  def comment=(content)
    comments.build content: content unless content.blank?
  end

end
