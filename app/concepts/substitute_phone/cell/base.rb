module SubstitutePhone::Cell
  class Base < BaseCell
    private

    def policy
      @policy ||= SubstitutePhonePolicy.new(current_user, model)
    end
  end
end
