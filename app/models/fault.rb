class Fault < ApplicationRecord
  belongs_to :causer, class_name: 'User'
  belongs_to :kind, class_name: 'FaultKind'
end
