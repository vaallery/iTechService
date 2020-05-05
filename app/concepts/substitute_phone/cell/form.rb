module SubstitutePhone::Cell
  class Form < Base
    self.translation_path = 'substitute_phones.form'
    private

    include FormCell
    include DepartmentsHelper
  end
end
