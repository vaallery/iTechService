class SubstitutePhone < ApplicationRecord

  class Index < Operation::Index
    policy!

    def model!(params)
      substitute_phones = params.has_key?(:available) ? SubstitutePhone.available : SubstitutePhone.all
      substitute_phones.search(params[:query])
    end
  end

  class Show < Operation::Base
    model!
    policy!
  end

  class Create < Operation::Persist
    model!
    policy!
    contract!
  end

  class Update < Operation::Persist
    model!
    policy!
    contract!
  end

  class Destroy < Operation::Destroy
    model!
    policy!
  end
end