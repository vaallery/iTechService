module SubstitutePhone::Cell
  class Table < BaseCell
    private

    include ModelCell

    def substitute_phones
      cell(SubstitutePhone::Cell::Preview, collection: model).()
    end
  end
end