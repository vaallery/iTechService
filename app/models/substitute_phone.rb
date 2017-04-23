class SubstitutePhone < ApplicationRecord
  include Authorizable

  scope :available, -> { where service_job_id: nil }

  belongs_to :item
  belongs_to :service_job
  has_many :features, through: :item

  delegate :name, :serial_number, :imei, to: :item

  def self.search(query)
    if query.blank?
      self.all
    else
      self.includes(:features).where('LOWER(features.value) LIKE :q', q: "%#{query.mb_chars.downcase.to_s}%").references(:features)
    end
  end

  def presentation
    [name, serial_number].compact.join(' / ')
  end
end
