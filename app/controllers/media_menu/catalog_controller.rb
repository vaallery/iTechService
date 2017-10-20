module MediaMenu
  class CatalogController < BaseController
    respond_to :html

    def index
      run Item::Index
      render_cell Cell::Catalog, layout: Cell::Layout
    end
  end
end