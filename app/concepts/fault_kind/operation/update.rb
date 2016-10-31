class FaultKind < ApplicationRecord
  class Update < ItechService::Operation
    model FaultKind, :update
    # policy Policy, :update?
    contract Form
  end
end