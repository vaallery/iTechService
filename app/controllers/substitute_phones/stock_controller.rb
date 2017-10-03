module SubstitutePhones
  class StockController < ApplicationController
    respond_to :js

    def index
      run SubstitutePhone::Stock::Index do
        return
      end
      failed
    end
  end
end