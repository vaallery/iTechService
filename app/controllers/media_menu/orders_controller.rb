module MediaMenu
  class OrdersController < BaseController

    def new
      run Order::Create::Present
      render_form
    end

    def create
      run Order::Create do
        return redirect_to media_menu_path
      end
      render_form
    end

    private

    def render_form
      render_cell Order::Cell::Form
    end
  end
end