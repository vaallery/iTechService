require "test_helper"

class TradeInDeviceTest < ActiveSupport::TestCase
  def trade_in_device
    @trade_in_device ||= TradeInDevice.new
  end

  def test_valid
    assert trade_in_device.valid?
  end
end
