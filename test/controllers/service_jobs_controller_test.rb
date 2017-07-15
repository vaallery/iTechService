require 'test_helper'

class ServiceJobsControllerTest < IntegrationTest

  def test_update
    service_job = create :service_job
    substitute_phone = create :substitute_phone
    put :update, id: service_job.id, service_job: {substitute_phone_id: substitute_phone.id, substitute_phone_icloud_connected: true}
    assert PhoneSubstitution.exists?(service_job: service_job, substitute_phone: substitute_phone)
  end
end