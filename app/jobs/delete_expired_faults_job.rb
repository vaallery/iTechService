class DeleteExpiredFaultsJob < ActiveJob::Base
  queue_as :default

  def perform
    DeleteExpiredFaults.()
  end
end