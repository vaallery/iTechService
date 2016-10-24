class Fault < ApplicationRecord
  belongs_to :kind, class_name: 'FaultKind'
end
