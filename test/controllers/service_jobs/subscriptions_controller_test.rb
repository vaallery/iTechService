require 'test_helper'

class ServiceJobs::SubscriptionsControllerTest < IntegrationTest
  before { sign_in current_user }

  def test_create
    service_job = create :service_job
    post service_job_subscriptions_path(service_job)
    assert_includes current_user, service_job.subscribers
  end
end