class SubstitutePhone < ApplicationRecord
  scope :available, -> { where service_job_id: nil }
  scope :in_department, ->(department) { where department_id: department }

  belongs_to :item
  belongs_to :department
  belongs_to :service_job
  has_many :features, through: :item
  has_many :substitutions, class_name: 'PhoneSubstitution'

  delegate :name, :serial_number, :imei, to: :item

  def self.search(query)
    if query.blank?
      self.all
    else
      self.includes(:features).where('LOWER(features.value) LIKE :q', q: "%#{query.mb_chars.downcase.to_s}%").references(:features)
    end
  end

  def pending_substitution
    substitutions.find_by(withdrawn_at: nil)
  end

  def presentation
    [name, serial_number].compact.join(' / ')
  end

  def issued?
    service_job.present?
  end
end
