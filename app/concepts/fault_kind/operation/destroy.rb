class FaultKind < ApplicationRecord
  class Destroy < ItechService::Operation::Destroy
    model FaultKind, :find
  end
end