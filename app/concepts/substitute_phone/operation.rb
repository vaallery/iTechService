class SubstitutePhone < ApplicationRecord

  class Index < Operation::Index
    policy!

    def model!(params)
      substitute_phones = SubstitutePhone.all
      if params.has_key?(:available)
        department = params[:current_user].department
        substitute_phones = substitute_phones.available.in_department department
      end
      substitute_phones.search(params[:query])
    end
  end

  class Show < Operation::Base
    policy!

    def model!(params)
      SubstitutePhone.includes(:substitutions).find(params[:id])
    end
  end

  class Create < Operation::Persist
    model!
    policy!
    contract Contract
  end

  class Update < Operation::Persist
    model!
    policy!
    contract Contract
  end

  class Destroy < Operation::Destroy
    model!
    policy!
  end
end