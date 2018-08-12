class StolenPhone < ActiveRecord::Base
  belongs_to :client
  belongs_to :item
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :features, through: :item
  attr_accessor :comment
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }
  delegate :presentation, to: :client, allow_nil: true, prefix: true
  attr_accessible :imei, :serial_number, :item_id, :client_id, :client_comment, :comment, :comments_attributes
  validates :client, presence: true
  validates_associated :comments

  def self.search(params)
    stolen_phones = StolenPhone.includes(:client).includes(item: {features: :feature_type})
    unless (imei_q = params[:imei_q]).blank?
      stolen_phones = stolen_phones.where('stolen_phones.imei LIKE :q OR (feature_types.kind = :kind AND features.value LIKE :q)', q: "%#{imei_q}%", kind: 'imei').references(:feature_types)
    end
    unless (serial_number_q = params[:serial_number_q]).blank?
      stolen_phones = stolen_phones.where('LOWER(stolen_phones.serial_number) LIKE :q OR (feature_types.kind = :kind AND LOWER(features.value) LIKE :q)', q: "%#{serial_number_q.mb_chars.downcase.to_s}%", kind: 'serial_number').references(:feature_types)
    end
    unless (client_q = params[:client_q]).blank?
      stolen_phones = stolen_phones.where('LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%").references(:clients)
    end
    stolen_phones
  end

  def comment=(content)
    comments.build content: content unless content.blank?
  end

  def imei
    item ? item.imei : self['imei']
  end

  def serial_number
    item ? item.serial_number : self['serial_number']
  end

  def item_presentation
    if item.nil?
      [imei.presence, serial_number.presence].compact.join(' / ')
    else
      [item.name, item.imei, item.serial_number].join(' / ')
    end
  end
end
