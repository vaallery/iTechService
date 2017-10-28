module MediaMenu
  class ItemsController < BaseController
    respond_to :js

    def index
      run Item::Index
      render 'index', locals: {content: cell(Item::Cell::Row, collection: @model).()}
    end

    def show
      model = Item.find params[:id]
      render 'show', locals: {content: cell(Item::Cell::Details, model).()}
    end
  end
end