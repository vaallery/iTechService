class Fault < ApplicationRecord
  class Update < ItechService::Operation
    model Fault, :update
    # policy Policy, :update?
    contract Form
  end
end