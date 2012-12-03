class DeviceType < ActiveRecord::Base
  attr_accessible :name, :ancestry, :parent_id
  validates :name, presence: true
  validates :name, uniqueness: true
  has_ancestry
  
  #default_scope order('ancestry')

  def full_name
    path.all.map { |t| t.name }.join ' '
  end

end
