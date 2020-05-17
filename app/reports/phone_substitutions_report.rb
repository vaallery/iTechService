class PhoneSubstitutionsReport < BaseReport
  def call
    substitutions = []
    PhoneSubstitution.in_department(department).pending.each do |substitution|
      substitutions << {substitute_phone: substitution.phone_presentation, ticket_number: substitution.ticket_number}
    end
    result[:substitutions] = substitutions
  end
end