module MediaMenu
  class CartItem::Create < BaseOperation
    step ->(options, params:, **) {
      options['model'] = CartItem.create item_id: params[:item_id]
    }
  end
end