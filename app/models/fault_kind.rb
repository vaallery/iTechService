class FaultKind < ApplicationRecord
  scope :permanent, -> { where is_permanent: true }
  scope :monthly, -> { where is_permanent: false }

  mount_uploader :icon, IconUploader
end
