class FaultKind < ApplicationRecord
  class Create < ItechService::Operation
    model FaultKind, :create
    # policy Policy, :create?
    contract Form
  end
end