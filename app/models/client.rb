class Client < ActiveRecord::Base
  include ApplicationHelper
  
  attr_accessible :name, :surname, :patronymic, :birthday, :email, :phone_number, :full_phone_number, :card_number, :admin_info, :comments_attributes, :comment, :contact_phone

  has_many :devices, inverse_of: :client, dependent: :destroy
  has_many :orders, as: :customer, dependent: :destroy
  has_many :purchases, class_name: 'Sale', inverse_of: :client, dependent: :nullify
  has_many :history_records, as: :object
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :sales, inverse_of: :client

  attr_accessor :comment
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }

  validates :name, :phone_number, :full_phone_number, presence: true
  validates :full_phone_number, uniqueness: true
  validates_associated :comments
  
  def self.search params
    clients = Client.scoped
    unless (client_q = params[:client_q] || params[:client]).blank?
      clients = Client.where 'LOWER(clients.surname) LIKE :q OR LOWER(clients.name) LIKE :q
                               OR LOWER(clients.patronymic) LIKE :q OR clients.phone_number LIKE :q
                               OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q',
                               q: "%#{client_q.mb_chars.downcase.to_s}%"
    end
    clients
  end

  def full_name
    [surname, name, patronymic].join ' '
  end

  def short_name
    [name, surname].join ' '
  end
  
  def name_phone
    "#{self.short_name} / #{self.human_phone_number}"
  end

  def presentation
    name_phone
  end
  
  def human_phone_number
    ActionController::Base.helpers.number_to_phone full_phone_number || phone_number, area_code: true
  end

  def comment=(content)
    comments.build content: content unless content.blank?
  end

  def purchases_sum
    purchases.sum :value
  end

  def discount_value
    Discount.for_sum purchases_sum
  end

  def creator
    self.history_records.first.try :user
  end

end
