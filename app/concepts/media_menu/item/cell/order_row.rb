module MediaMenu
  module Item::Cell
    class OrderRow < Card
      private

      def button_to_remove
        button_tag content_tag(:i, nil, class: 'fa fa-close'),
                   type: 'button', class: 'btn btn-sm btn-outline-danger pull-right',
                   data: {behaviour: 'remove-media_menu-order_item', id: id}
      end
    end
  end
end
