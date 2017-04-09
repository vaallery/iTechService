class SubstitutePhone < ApplicationRecord
  class Policy < BasePolicy

    def index?
      user.present?
    end
  end
end