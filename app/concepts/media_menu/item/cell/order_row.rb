module MediaMenu
  module Item::Cell
    class OrderRow < Card
      private

      def button_to_remove
        button_tag '&times;', type: 'button', class: 'btn btn-sm btn-outline-danger pull-right font-weight-bold',
                   data: {behaviour: 'remove-media_menu-order_item', id: id}
      end
    end
  end
end
