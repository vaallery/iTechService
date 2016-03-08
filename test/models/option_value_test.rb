require "test_helper"

class OptionValueTest < ActiveSupport::TestCase
  def option_value
    @option_value ||= OptionValue.new
  end

  def test_valid
    assert option_value.valid?
  end
end
