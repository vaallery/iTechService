module MediaMenu
  class CartItem < ApplicationRecord
    self.table_name = 'media_menu_cart_items'

    belongs_to :item, inverse_of: :cart_item
    delegate :name, :track_number, to: :item
  end
end
