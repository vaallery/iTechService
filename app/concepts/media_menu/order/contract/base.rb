module MediaMenu
  module Order
    module Contract
      class Base < BaseContract
        properties :name, :phone
        validates :name, :phone, presence: true
      end
    end
  end
end