module MediaMenu
  class CartItemsController < BaseController
    respond_to :js

    def create
      run CartItem::Create
      item = @model.item.reload
      render 'update_button', locals: {item_id: item.id, button_content: button_content(item)}
    end

    def destroy
      run CartItem::Destroy do |result|
        item = result['item'].reload
        return render 'update_button', locals: {item_id: item.id, button_content: button_content(item)}
      end
      render js: "alert(#{operation_message});"
    end

    private

    def button_content(item)
      cell(MediaMenu::Item::Cell::Card, item).(:selection_button)
    end
  end
end
