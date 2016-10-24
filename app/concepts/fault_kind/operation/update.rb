class FaultKind < ApplicationRecord
  class Update < ItechService::Operation
    model FaultKind, :update
    contract Form
  end
end