module Service
  module FreeJob::Contract
    class Base < BaseContract
      model 'service/free_job'
      properties :client, :client_id, :task, :task_id, :comment
      validates :client_id, :task_id, presence: true
    end
  end
end
