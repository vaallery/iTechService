module Service
  class Feedback::Policy < BasePolicy
    def update?
      user.location_id == record.service_job.location_id
    end
  end
end