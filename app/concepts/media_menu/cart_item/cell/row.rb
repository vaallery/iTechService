module MediaMenu::CartItem::Cell
  class Row < BaseCell
    private

    include ModelCell

    property :id, :name

    def remove_button
      name = content_tag :i, nil, class: 'fa fa-close'
      url = "/media_menu/cart_items/#{id}"
      options = {method: :delete, remote: true, class: 'btn btn-sm btn-outline-danger pull-right'}
      link_to name, url, options
    end
  end
end
