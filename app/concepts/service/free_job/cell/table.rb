module Service
  module FreeJob::Cell
    class Table < BaseCell
      private

      include IndexCell
      alias free_jobs model

      def caption
        t 'shared.navbar.free_jobs'
      end
    end
  end
end
