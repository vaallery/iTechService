require "test_helper"

class ServiceJobTemplateTest < ActiveSupport::TestCase
  def service_job_template
    @service_job_template ||= Service::JobTemplate.new
  end

  def test_valid
    assert service_job_template.valid?
  end
end
