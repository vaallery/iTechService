class FaultKind < ApplicationRecord
  class Create < ItechService::Operation
    model FaultKind, :create
    contract Form
  end
end