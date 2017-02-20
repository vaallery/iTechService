require "test_helper"

class SendEmailWhenServiceJobReadyTest < IntegrationTest

  before do
    sign_in current_user
  end

  def test_sending_email
    bar_location = create :location, :bar
    done_location = create :location, :done
    email = 'test@example.com'
    service_job = create :service_job, email: email, location: bar_location
    assert_difference 'ActionMailer::Base.deliveries.size' do
      put service_job, params: {servie_job: {location_id: done_location.id}}
    end
    notification_email = ActionMailer::Base.deliveries.last
    assert_equal email, notification_email.to[0]
  end
end
