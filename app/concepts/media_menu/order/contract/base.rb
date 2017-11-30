module MediaMenu::Order::Contract
  class Base < BaseContract
    model :media_order
    properties :name, :phone
    validates :name, :phone, presence: true
  end
end
