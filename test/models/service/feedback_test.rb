require "test_helper"

module Service
  class FeedbackTest < ActiveSupport::TestCase
    def feedback
      @feedback ||= Feedback.new
    end

    def test_valid
      assert feedback.valid?
    end
  end
end
