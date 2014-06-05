class ImportedSale < ActiveRecord::Base
  scope :sold_at, lambda { |period| where(sold_at: period) }
  belongs_to :device_type
  attr_accessible :imei, :quantity, :serial_number, :sold_at

  def self.search(params)
    sales = ImportedSale.scoped

    if (search = params[:search]).present?
      sales = sales.where 'LOWER(sales.serial_number) = :s OR LOWER(sales.imei) = :s', s: "#{search.mb_chars.downcase.to_s}"
    end

    sales
  end

  def device_type_name
    device_type.present? ? device_type.full_name : '-'
  end

end
