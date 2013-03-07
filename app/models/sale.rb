class Sale < ActiveRecord::Base
  belongs_to :device_type
  attr_accessible :imei, :serial_number, :sold_at, :device_type_id, :quantity

  def device_type_name
    device_type.present? ? device_type.full_name : '-'
  end

  def self.search(params)
    sales = Sale.scoped
    if (search = params[:search]).present?
      sales = sales.where 'LOWER(sales.serial_number) = :s OR LOWER(sales.imei) = :s',
                          s: "#{search.mb_chars.downcase.to_s}"
    end
    sales
  end
end
