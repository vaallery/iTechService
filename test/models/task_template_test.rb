require 'test_helper'

class TaskTemplateTest < ActiveSupport::TestCase
  def template
    @template ||= TaskTemplate.new
  end

  def test_valid
    assert template.valid?
  end
end
