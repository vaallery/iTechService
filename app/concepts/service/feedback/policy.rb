module Service
  class Feedback::Policy < BasePolicy
    def update?
      user.location_id == record.service_job.location_id || user.able_to_view_feedbacks?
    end
  end
end
