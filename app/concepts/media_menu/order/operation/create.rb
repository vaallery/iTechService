module MediaMenu
  class Order::Create < BaseOperation
    class Present < BaseOperation
      step Model(MediaOrder, :new)
      step :order_items
      failure :no_selected_items
      step Contract.Build(constant: MediaMenu::Order::Contract::Base)

      private

      def order_items(options, params:, **)
        item_ids = params[:selected_items].split(',')
        items = MediaMenu::Item.where(Z_PK: item_ids)
        options['order_items'] = items
      end

      def no_selected_items(options, **)
        options['result.message'] = t('.errors.no_selected_items')
      end
    end

    step Nested(Present)
    step Contract.Validate(key: :media_order)
    failure :contract_invalid!
    step :set_content
    step :set_time
    step Contract.Persist

    def set_content(*, model:, order_items:, **)
      content = ''
      order_items.each do |order_item|
        content << "	•	#{order_item.track_number} - #{order_item.name}\n"
      end
      model.content = content
    end

    def set_time(*, model:, **)
      model.time = Time.current
    end
  end
end