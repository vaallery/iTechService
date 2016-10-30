class Fault < ApplicationRecord
  class Form < ItechService::Form
    model Fault
    properties :causer_id, :kind_id, :date, :comment
    properties :causer, :kind, writeable: false
    validates :causer_id, :kind_id, :date, presence: true

    def causer_name
      causer&.short_name
    end

    def kinds
      FaultKind.select(:id, :name).ordered
    end
  end
end