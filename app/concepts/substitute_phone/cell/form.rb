module SubstitutePhone::Cell
  class Form < BaseCell
    self.translation_path = 'substitute_phones.form'
    private

    include FormCell
    include DepartmentsHelper
  end
end
