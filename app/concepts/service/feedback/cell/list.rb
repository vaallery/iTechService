module Service
  module Feedback::Cell
    class List < BaseCell
      include IndexCell
      include ActionView::Helpers::DateHelper

      private

      def feedbacks
        model
      end
    end
  end
end
