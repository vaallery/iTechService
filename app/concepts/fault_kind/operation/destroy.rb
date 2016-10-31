class FaultKind < ApplicationRecord
  class Destroy < ItechService::Operation::Destroy
    model FaultKind, :find
    # policy Policy, :destroy?
  end
end