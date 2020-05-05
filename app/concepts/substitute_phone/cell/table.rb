module SubstitutePhone::Cell
  class Table < Base
    private

    include ModelCell

    def substitute_phones
      cell(SubstitutePhone::Cell::Preview, collection: model).()
    end
  end
end