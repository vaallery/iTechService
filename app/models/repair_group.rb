class RepairGroup < ActiveRecord::Base
  has_ancestry orphan_strategy: :restrict, cache_depth: true
  has_many :repair_services, primary_key: :uid
  attr_accessible :ancestry, :name, :parent_id
  validates_presence_of :name
  after_create UidCallbacks

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

end
