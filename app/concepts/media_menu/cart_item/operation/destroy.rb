module MediaMenu
  class CartItem::Destroy < BaseOperation
    step Model(MediaMenu::CartItem, :find_by)
    failure :record_not_found!, fail_fast: true
    step ->(options, model:, **) { options['item'] = model.item }
    step ->(*, model:, **) { model.destroy }
  end
end
