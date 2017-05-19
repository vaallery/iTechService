require "test_helper"

class PhoneSubstitutionTest < ActiveSupport::TestCase
  def phone_substitution
    @phone_substitution ||= PhoneSubstitution.new
  end

  def test_valid
    assert phone_substitution.valid?
  end
end
