class ClientCategory < ActiveRecord::Base
  default_scope order('id asc')
  attr_accessible :color, :name
  validates_presence_of :name
  after_initialize { color ||= '#ffffff' }
  after_create UidCallbacks

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

end
