module MediaMenu
  class CatalogController < BaseController
    respond_to :html

    def index
      run Item::Index do |result|
        return render_cell Cell::Catalog, result: result, layout: Cell::Layout
      end
      render html: operation_message
    end
  end
end