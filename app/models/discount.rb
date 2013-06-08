class Discount < ActiveRecord::Base

  attr_accessible :limit, :value

  def self.for_sum(sum)
    where('discounts.limit <= ?', sum).maximum('value')
  end

end
