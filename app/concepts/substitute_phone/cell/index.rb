module SubstitutePhone::Cell
  class Index < BaseCell
    self.translation_path = 'substitute_phones.index'

    private

    include IndexCell

    def table
      if collection.any?
        cell(Table, collection).()
      else
        nothing_found_message
      end
    end
  end
end