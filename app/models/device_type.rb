class DeviceType < ActiveRecord::Base
  attr_accessible :name, :ancestry, :parent_id, :qty_for_replacement, :qty_replaced
  validates :name, presence: true
  validates :name, uniqueness: true
  has_ancestry

  #default_scope order('ancestry')

  def full_name
    path.all.map { |t| t.name }.join ' '
  end

  def available_for_replacement
    qty_for_replacement - qty_replaced
  end

  def has_imei?
    %w[iphone ipad].include? root.name.downcase
  end

  def is_iphone?
    root.name.downcase == 'iphone'
  end

end
