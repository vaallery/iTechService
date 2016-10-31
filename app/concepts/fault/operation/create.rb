class Fault < ApplicationRecord
  class Create < ItechService::Operation
    model Fault, :create
    # policy Policy, :create?
    contract Form

    private

    def setup_model!(params)
      user = User.find params[:user_id]
      model.causer = user
    end
  end
end