module Service
  module RepairReturn::Cell
    class Index < BaseCell
      private

      include IndexCell
      include Kaminari::Cells

      def title
        t '.title.index'
      end

      def pagination
        paginate collection, theme: 'bootstrap-2', remote: true
      end

      def date_placeholder
        t 'attributes.date'
      end

      def performer_placeholder
        t_attribute :performer
      end

      def datepicker_data
        {
          'date-format': 'dd.mm.yyyy',
          'date-weekStart': 1
        }
      end

      def repair_return_rows
        cell(Preview, collection: collection).call
      end
    end
  end
end