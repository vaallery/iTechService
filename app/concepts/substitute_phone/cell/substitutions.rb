module SubstitutePhone::Cell
  class Substitutions < Base
    private

    def issued_at
      t 'substitute_phones.show.substitutions.issued_at'
    end

    def issued_to
      t 'substitute_phones.show.substitutions.issued_to'
    end

    def issued_by
      t 'substitute_phones.show.substitutions.issued_by'
    end

    def condition_match
      t 'substitute_phones.show.substitutions.condition_match'
    end

    def substitutions
      cell(PhoneSubstitution::Cell::Preview, collection: model.ordered).call
    end
  end
end
