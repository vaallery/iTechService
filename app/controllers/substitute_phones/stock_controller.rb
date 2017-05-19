module SubstitutePhones
  class StockController < ApplicationController
    def index
      present SubstitutePhone::Index, params: {available: true}
    end
  end
end