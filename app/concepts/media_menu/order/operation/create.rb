module MediaMenu
  class Order::Create < BaseOperation
    class Present < BaseOperation
      step Model(MediaOrder, :new)
      step :cart_items
      step Contract.Build(constant: MediaMenu::Order::Contract::Base)

      private

      def cart_items(options, **)
        options['cart_items'] = CartItem.all
      end
    end

    step Nested(Present)
    step Contract.Validate(key: :media_order)
    failure :contract_invalid!
    step :set_content
    step :set_time
    step Contract.Persist
    step ->(*, cart_items:, **) { cart_items.delete_all }

    def set_content(*, model:, cart_items:, **)
      content = ''
      cart_items.each do |order_item|
        content << "	•	#{order_item.track_number} - #{order_item.name}\n"
      end
      model.content = content
    end

    def set_time(*, model:, **)
      model.time = Time.current
    end

    # TYPES = {0 => 'Книги', 1 => 'Приложения', 2 => 'Музыка', 3 => 'Телешоу', 4 => 'Фильмы', 5 => 'Аудиокниги'}
    # orders = params[:orders]
    # orders.each do |_, order|
    #   items = {}
    #   order['items'].each do |item|
    #     order_item = "	•	#{item['filmNumber']} - #{item[:name]}"
    #     item_type = TYPES[item['classType']]
    #     items[item_type] = [] unless items[item_type].present?
    #     items[item_type] << order_item
    #   end
    #   content = ''
    #   items.each do |_type, _items|
    #     content << "#{_type}\n\n#{_items.join("\n")}"
    #   end
    #   MediaOrder.create time: order[:date], name: order[:name], phone: order[:phone], content: content
  end
end