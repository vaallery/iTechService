class Fault::Contract::Base < BaseContract
  model :fault
  properties :causer_id, :kind_id, :date, :comment, :penalty
  properties :causer, :kind, :description, writeable: false
  validates :causer_id, :kind_id, :date, presence: true
end
