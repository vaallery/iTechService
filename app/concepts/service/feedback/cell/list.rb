module Service
  module Feedback::Cell
    class List < BaseCell
      include IndexCell

      private

      def feedbacks
        model
      end
    end
  end
end
