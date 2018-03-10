module Service
  module Feedback::Contract
    class Update < BaseContract
      property :details
      validates :details, presence: true

      # validation do
      #   required(:details).filled
      #   # optional(:scheduled_on).maybe(:date_time?)
      #   # optional(:scheduled_on).maybe(:date_time?, lt?: Service::Feedback.max_delay_hours_for_job(service_job))
      # end
    end
  end
end
