module MediaMenu
  class CartItem < ApplicationRecord
    self.table_name = 'media_menu_cart_items'

    belongs_to :item
  end
end
