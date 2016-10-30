class FaultKind < ApplicationRecord
  scope :ordered, -> { order :name }
  scope :permanent, -> { where is_permanent: true }
  scope :monthly, -> { where is_permanent: false }

  mount_uploader :icon, IconUploader
end
