module SubstitutePhone::Stock::Cell
  class Index < BaseCell
    self.translation_path = 'substitute_phones.stock'

    private

    include IndexCell

    def empty?
      collection.empty?
    end

    def substitute_phones
      cell(Item, collection: collection).()
    end
  end
end
