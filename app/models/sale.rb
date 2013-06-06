class Sale < ActiveRecord::Base

  attr_accessible :imei, :serial_number, :sold_at, :device_type_id, :quantity, :value, :client_id, :user_id
  belongs_to :device_type
  belongs_to :client, inverse_of: :purchases

  before_validation :set_user
  after_initialize :set_user

  scope :sold_at, lambda { |period| where(sold_at: period) }

  def device_type_name
    device_type.present? ? device_type.full_name : '-'
  end

  def self.search(params)
    sales = Sale.scoped
    if (search = params[:search]).present?
      sales.where 'LOWER(sales.serial_number) = :s OR LOWER(sales.imei) = :s', s: "#{search.mb_chars.downcase.to_s}"
    end
    sales
  end

  def client_presentation
    client.present? ? client.presentation : '-'
  end

  private

  def set_user
    self.user_id ||= User.try(:current).try(:id)
  end

end
