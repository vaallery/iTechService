class PhoneSubstitution < ActiveRecord::Base
  scope :ordered, -> { order issued_at: :desc }
  scope :pending, -> { where withdrawn_at: nil }

  belongs_to :substitute_phone
  belongs_to :service_job
  belongs_to :issuer, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  delegate :client, :ticket_number, to: :service_job

  def pending?
    withdrawn_at.nil?
  end

  def phone_presentation
    substitute_phone.presentation
  end
end
