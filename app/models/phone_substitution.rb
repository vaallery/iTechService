class PhoneSubstitution < ActiveRecord::Base
  scope :ordered, (-> { order issued_at: :desc })

  belongs_to :substitute_phone
  belongs_to :service_job
  belongs_to :issuer, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  delegate :client, to: :service_job

  def pending?
    withdrawn_at.nil?
  end
end
