class ClientCategory < ActiveRecord::Base
  default_scope order('id asc')
  attr_accessible :color, :name
  validates_presence_of :name
  after_initialize { color ||= '#ffffff' }
  after_create UidCallbacks
end
