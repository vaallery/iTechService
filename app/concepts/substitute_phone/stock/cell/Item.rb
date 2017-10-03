module SubstitutePhone::Stock::Cell
  class Item < BaseCell
    self.translation_path = 'substitute_phones.stock'

    private

    property :id, :name, :serial_number, :imei

    def link_to_select
      link_to t('.select'), '#', class: 'btn', 'data-behaviour': 'select-substitute-phone'
    end
  end
end