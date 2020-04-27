module Service
  class FeedbackPolicy < BasePolicy
    def update?
      (user.location_id == record.service_job.location_id) || superadmin? || able_to?(:view_feedback_notifications)
    end

    class Scope < Scope
      def resolve
        if user.superadmin? || user.able_to?(:view_feedback_notifications)
          excluded_location_ids = Location.select(:id).where(code: %w[archive done special]).pluck(:id)
          service_job_ids = ServiceJob.select(:id).where.not(location_id: excluded_location_ids).pluck(:id)
        else
          service_job_ids = ServiceJob.select(:id).where(location_id: user.location_id).pluck(:id)
        end
        scope.where(service_job_id: service_job_ids)
      end
    end
  end
end
