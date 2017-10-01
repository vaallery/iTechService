module SubstitutePhone::Cell
  class Show < Preview
    property :condition
    delegate :human_attribute_name, to: :SubstitutePhone

    def title
      t 'substitute_phones.show.title'
    end

    def attribute_presentation(attr_name)
      content_tag :tr do
        content_tag(:td, human_attribute_name(attr_name)) +
        content_tag(:td, send(attr_name))
      end
    end

    def department
      model.department.name unless model.department.nil?
    end

    def substitutions
      cell(Substitutions, model.substitutions).call
    end
  end
end
