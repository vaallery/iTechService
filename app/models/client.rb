class Client < ActiveRecord::Base
  include ApplicationHelper
  
  has_many :devices, inverse_of: :client, dependent: :destroy
  has_many :orders, as: :customer, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  attr_accessible :name, :surname, :patronymic, :birthday, :email, :phone_number, :full_phone_number, :card_number,
                  :admin_info, :comments_attributes, :comment
  attr_accessor :comment
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }
  validates :name, :phone_number, :full_phone_number, presence: true
  validates_associated :comments
  
  def self.search params
    clients = Client.scoped
    unless (client_q = params[:client_q] || params[:client]).blank?
      clients = clients.where 'LOWER(clients.surname) LIKE :q OR LOWER(clients.name) LIKE :q
                               OR LOWER(clients.patronymic) LIKE :q OR clients.phone_number LIKE :q
                               OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q',
                               q: "%#{client_q.downcase}%"
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
    "#{self.name} / #{self.human_phone_number}"
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

end
