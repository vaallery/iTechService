class ClientCharacteristic < ActiveRecord::Base
  belongs_to :client_category
  has_one :client, dependent: :nullify
  attr_accessible :comment, :client_category_id
  #validates_presence_of :client_category
  delegate :name, :color, to: :client_category, allow_nil: true
end
