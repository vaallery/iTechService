module MediaMenu
  class OrdersController < BaseController

    def new
      run MediaMenu::Order::Create::Present
      render_form
    end

    def create
      run MediaMenu::Order::Create do
        return redirect_to media_menu_path
      end
      flash.alert = operation_message
      render_form
    end

    private

    def render_form
      render_cell MediaMenu::Order::Cell::Form, cart_items: result['cart_items'], layout: Cell::Layout
    end
  end
end