require "test_helper"

class DeviceTest < ActiveSupport::TestCase
  def device
    @device ||= Device.new
  end

  def test_valid
    assert device.valid?
  end
end
