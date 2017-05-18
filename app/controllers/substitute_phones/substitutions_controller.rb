module SubstitutePhones
  class SubstitutionsController < ApplicationController

    def edit
      form SubstitutePhone::Substitution::Update
    end

    def update
      run SubstitutePhone::Substitution::Update do |op|
        return redirect_to substitute_phone_path(op.model.substitute_phone_id), notice: t('substitute_phones.returned')
      end
      render :edit
    end
  end
end