class DeviceType < ActiveRecord::Base
  has_many :devices
  attr_accessible :name, :ancestry, :parent_id, :qty_for_replacement, :qty_replaced, :qty_shop,
                  :qty_store, :qty_reserve, :expected_during, :code_1c
  validates :name, presence: true
  #validates :name, uniqueness: true
  has_ancestry

  #scope :not_root, where('ancestry != NULL')
  #scope :for_sale, not_root.and(self.arel_table[:descendants_count].eq(0))

  def full_name
    path.all.map { |t| t.name }.join ' '
  end

  def available_for_replacement
    qty_for_replacement - qty_replaced
  end

  def has_imei?
    is_childless? and /iPhone|iPad.*Cellular/i === full_name
  end

  def is_iphone?
    root.name.mb_chars.downcase.to_s.start_with? 'iphone'
  end

  def self.for_sale
    all.select{|dt|dt.is_childless?}.sort_by!{|dt|dt.full_name}
  end

  def self.search_by_full_name(search)
    res = nil
    all.select do |dt|
      res = dt if dt.ancestry.present? and dt.is_childless? and dt.full_name == search
    end
    res
  end

end
