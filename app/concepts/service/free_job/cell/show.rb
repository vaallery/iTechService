module Service
  module FreeJob::Cell
    class Show < Preview
      private

      property :comment

      def title
        FreeJob.model_name.human
      end
    end
  end
end
