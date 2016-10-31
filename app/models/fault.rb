class Fault < ApplicationRecord
  belongs_to :causer, class_name: 'User'
  belongs_to :kind, class_name: 'FaultKind'

  scope :ordered, -> { order date: :desc }

  delegate :name, :icon, :icon_url, to: :kind, allow_nil: true
end
