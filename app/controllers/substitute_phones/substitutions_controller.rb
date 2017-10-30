module SubstitutePhones
  class SubstitutionsController < ApplicationController

    def edit
      form SubstitutePhone::Substitution::Update
    end

    def update
      run SubstitutePhone::Substitution::Update do
        return redirect_to substitute_phones_path, notice: t('substitute_phones.returned')
      end
      render :edit
    end
  end
end