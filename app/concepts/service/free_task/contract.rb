module Service
  module FreeTask::Contract
    class Base < BaseContract
      model 'service/free_task'
      properties :name, :icon, :code
      validates :name, presence: true
    end
  end
end
