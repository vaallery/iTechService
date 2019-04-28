module Service
  module FreeJob::Contract
    class Base < BaseContract
      model 'service/free_job'
      properties :client, :client_id, :task, :task_id, :comment, :performer, :performer_id
      validates :client_id, :task_id, presence: true
    end
  end
end
