require "test_helper"

class FaultKindTest < ActiveSupport::TestCase
  def fault_kind
    @fault_kind ||= FaultKind.new
  end

  def test_valid
    assert fault_kind.valid?
  end
end
