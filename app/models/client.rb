class Client < ActiveRecord::Base
  include ApplicationHelper
  

  CATEGORIES = {
    0 => 'usual',
    1 => 'regular',
    2 => 'super',
    3 => 'friend'
  }

  attr_accessible :name, :surname, :patronymic, :birthday, :email, :phone_number, :full_phone_number, :card_number, :admin_info, :comments_attributes, :comment, :contact_phone, :category, :client_characteristic_attributes

  has_many :devices, inverse_of: :client, dependent: :destroy
  has_many :orders, as: :customer, dependent: :destroy
  has_many :purchases, class_name: 'Sale', inverse_of: :client, dependent: :nullify
  has_many :history_records, as: :object
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :client_characteristic
  has_many :sales, inverse_of: :client

  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }
  accepts_nested_attributes_for :client_characteristic, allow_destroy: true

  delegate :client_category, to: :client_characteristic, allow_nil: true

  scope :id_asc, order('id asc')

  validates :name, :phone_number, :full_phone_number, presence: true
  validates :full_phone_number, uniqueness: true
  validates_presence_of :name, :phone_number, :full_phone_number, :category
  validates_uniqueness_of :full_phone_number
  validates_inclusion_of :category, in: CATEGORIES.keys
  validates_associated :comments
  validates_associated :client_characteristic


  after_initialize do |client|
    client.build_client_characteristic if client.client_characteristic.nil?
    client.category ||= 0
  end

  def self.search params
    clients = Client.scoped
    unless (client_q = params[:client_q] || params[:client]).blank?
      client_q.chomp.split(/\s+/).each do |q|
        clients = clients.where ['LOWER(clients.surname) LIKE :q OR LOWER(clients.name) LIKE :q OR LOWER(clients.patronymic) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{q.mb_chars.downcase.to_s}%"]
      end
      clients = Client.where 'LOWER(clients.surname) LIKE :q OR LOWER(clients.name) LIKE :q OR LOWER(clients.patronymic) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
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
    #purchases.sum :value
    0
    #purchases.sum :value
  end

  def discount_value
    #Discount.for_sum purchases_sum
  end

  def creator
    self.history_records.first.try :user
  end

  def category_name
    client_category.present? ? client_category.name : nil
  end

  def category_color
    client_category.present? ? client_category.color : '#000000'
  end

  def characteristic
    client_characteristic.present? ? client_characteristic.comment : nil
  end

  def category_s
    CATEGORIES[category]
  end

end
