module SubstitutePhones
  class StockController < ApplicationController
    skip_after_action :verify_authorized
    respond_to :js

    def index
      run SubstitutePhone::Stock::Index do
        return
      end
      failed
    end
  end
end