module MediaMenu
  class CartItemsController < BaseController
    respond_to :js

    def create
      run CartItem::Create
      render 'update_button', locals: {item: @model.item}
    end

    def destroy
      run CartItem::Destroy do |result|
        return render 'update_button', locals: {item: result['item']}
      end
      render js: "alert(#{operation_message});"
    end
  end
end
