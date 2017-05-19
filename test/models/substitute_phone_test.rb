require 'test_helper'

class SubstitutePhoneTest < ActiveSupport::TestCase
  def substitute_phone
    @substitute_phone ||= build :substitute_phone
  end

  def test_valid
    assert substitute_phone.valid?
  end
end
