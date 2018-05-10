require "test_helper"

class Service::FreeJobTest < ActiveSupport::TestCase
  def free_job
    @free_job ||= Service::FreeJob.new
  end

  def test_valid
    assert free_job.valid?
  end
end
