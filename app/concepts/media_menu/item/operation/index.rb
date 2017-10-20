module MediaMenu
  class Item::Index < BaseOperation
    step ->(options, params:, **) {
      sort_param = params.key?(:sort_by) ? [params[:sort_by], params.fetch(:sort_dir, :asc)] : [:name, :asc]
      items = Item.movies.sort_by(*sort_param).search(params[:search]).page(params[:page]).per(50)
      options['model'] = items
    }
  end
end
