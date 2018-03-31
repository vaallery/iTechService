module Service
  module Job::Cell
    class Feedbacks < BaseCell
      private

      def feedbacks
        model.feedbacks.old_first
      end
    end
  end
end