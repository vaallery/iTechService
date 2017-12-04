module MediaMenu::Order::Cell
  class Form < BaseCell
    self.translation_path = 'media_menu.order.view'

    private

    include FormCell
    include ActiveSupport::NumberHelper

    def total_count
      t '.total_selected', count: order_items.count
    end

    def total_size
      sum = order_items.map(&:size).sum
      number_to_human_size sum
    end

    def order_item_rows
      MediaMenu::Item::Cell::OrderRow.(collection: order_items)
    end

    def order_items
      options[:order_items]
    end

    def icon(name)
      content_tag :i, nil, class: "fa fa-#{name}"
    end
  end
end
