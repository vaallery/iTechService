class FaultKind < ApplicationRecord
  scope :ordered, -> { order :name }
  scope :permanent, -> { where is_permanent: true }
  scope :expireable, -> { where is_permanent: false }
  scope :monthly, -> { expireable }

  mount_uploader :icon, IconUploader
end
