require "test_helper"

class FaultTest < ActiveSupport::TestCase
  def fault
    @fault ||= Fault.new
  end

  def test_valid
    assert fault.valid?
  end
end
