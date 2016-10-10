class TaskTemplate < ActiveRecord::Base
  scope :ordered, -> { order :position }

  has_ancestry orphan_strategy: :restrict
  mount_uploader :icon, IconUploader
end
