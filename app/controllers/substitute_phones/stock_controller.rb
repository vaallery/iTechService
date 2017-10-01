module SubstitutePhones
  class StockController < ApplicationController
    def index
      respond_to :js
      run SubstitutePhone::Index, available: true do
        return render :index, locals: {substitute_phones: operation_model}
      end
      failed
    end
  end
end