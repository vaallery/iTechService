class Supply < ActiveRecord::Base

  belongs_to :supply_report
  belongs_to :supply_category
  attr_accessible :name, :cost, :quantity, :supply_report_id, :supply_category_id
  validates_presence_of :name, :cost, :quantity, :supply_category, :supply_report

  def sum
    (cost || 0) * (quantity || 0)
  end

end
