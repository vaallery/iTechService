class Fault < ApplicationRecord
  class Destroy < ItechService::Operation::Destroy
    model Fault, :find
    # policy Policy, :destroy?
  end
end