# module Service
  module QuickOrder::Cell
    class Table < BaseCell
      private

      include IndexCell
      alias quick_orders model

      def caption
        t 'quick_orders.index.title'
      end
    end
  end
# end
