module PhoneSubstitution::Cell
  class Preview < BaseCell
    include ModelCell

    def issued_at
      l model.issued_at, format: :long
    end

    def issued_to
      link_to model.client.short_name, model.service_job
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
