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
    step :assign_attributes
    step Contract.Persist

    # TYPES = {0 => 'Книги', 1 => 'Приложения', 2 => 'Музыка', 3 => 'Телешоу', 4 => 'Фильмы', 5 => 'Аудиокниги'}
    def assign_attributes(*, model:, order_items:, **)
      content = "Фильмы\n\n"
      order_items.each do |order_item|
        content << "	•	#{order_item.track_number} - #{order_item.name}\n"
      end
      model.content = content
      model.time = Time.current
      model.department = Department.find_by_code('vl')
    end
  end
end