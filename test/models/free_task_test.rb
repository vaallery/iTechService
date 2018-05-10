require "test_helper"

class FreeTaskTest < ActiveSupport::TestCase
  def free_task
    @free_job_task ||= FreeTask.new
  end

  def test_valid
    assert free_task.valid?
  end
end
