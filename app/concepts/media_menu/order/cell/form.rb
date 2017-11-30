module MediaMenu::Order::Cell
  class Form < BaseCell
    self.translation_path = 'media_menu.order.view'

    private

    include FormCell

    def cart_items
      MediaMenu::CartItem::Cell::Row.(collection: options[:cart_items])
    end

    def icon(name)
      content_tag :i, nil, class: "fa fa-#{name}"
    end
  end
end
