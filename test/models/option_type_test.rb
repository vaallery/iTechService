require "test_helper"

class OptionTypeTest < ActiveSupport::TestCase
  def option_type
    @option_type ||= OptionType.new
  end

  def test_valid
    assert option_type.valid?
  end
end
