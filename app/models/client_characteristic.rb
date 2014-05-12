class ClientCharacteristic < ActiveRecord::Base
  belongs_to :client_category, primary_key: :uid
  has_one :client, dependent: :nullify, primary_key: :uid
  delegate :name, :color, to: :client_category, allow_nil: true
  attr_accessible :comment, :client_category_id
  after_create UidCallbacks
end
