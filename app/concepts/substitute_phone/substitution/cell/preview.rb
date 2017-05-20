class SubstitutePhone < ApplicationRecord
  module Substitution
    module Cell
      class Preview < BaseCell

        def issued_at
          l model.issued_at, format: :long
        end

        def issued_to
          model.client.short_name
        end

        def issued_by
          model.issuer.short_name
        end

        def condition_match
          return if model.condition_match.nil?
          icon_name = model.condition_match ? 'plus' : 'minus'
          icon icon_name
        end
      end
    end
  end
end