module Service
  class FreeJob < ActiveRecord::Base
    self.table_name = 'service_free_jobs'

    scope :in_department, ->(department) { where department_id: department }
    scope :new_first, -> { order performed_at: :desc }

    belongs_to :department, required: true
    belongs_to :receiver, class_name: 'User'
    belongs_to :performer, class_name: 'User'
    belongs_to :client
    belongs_to :task, class_name: 'FreeTask'
    has_many :comments, as: :commentable, dependent: :destroy

    delegate :presentation, :short_name, to: :client, prefix: true
    delegate :short_name, to: :receiver, prefix: true
    delegate :short_name, to: :performer, prefix: true
    delegate :code, to: :task, prefix: true
  end
end
