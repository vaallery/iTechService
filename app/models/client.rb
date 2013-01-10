class Client < ActiveRecord::Base
  include ApplicationHelper
  
  has_many :devices, inverse_of: :client
  attr_accessible :name, :phone_number, :card_number
  
  validates :name, :phone_number, presence: true
  
  def self.search params
    clients = Client.scoped
    
    unless (client_q = params[:client]).blank?
      clients = clients.where 'LOWER(clients.name) LIKE :q OR clients.phone_number LIKE :q',
          q: "%#{client_q.downcase}%"
    end
    
    clients
  end
  
  def name_phone
    "#{self.name} / #{self.human_phone_number}"
  end
  
  def human_phone_number
    ActionController::Base.helpers.number_to_phone self.phone_number, area_code: true
  end
  
end
