class SubstitutePhone < ApplicationRecord

  class Index < Operation::Index
    policy!

    def model!(params)
      substitute_phones = params.has_key?(:available) ? SubstitutePhone.available : SubstitutePhone.all
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