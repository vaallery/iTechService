module Service
  class FeedbackPolicy < BasePolicy
    def update?
      (user.location_id == record.service_job.location_id) || superadmin? || able_to?(:view_feedback_notifications)
    end

    class Scope < Scope
      def resolve
        if user.superadmin? || user.able_to?(:view_feedback_notifications)
          location_ids = Location.select(:id).where.not(code: %w[archive done special]).pluck(:id)
          service_job_ids = ServiceJob.select(:id).where(location_id: location_ids).pluck(:id)
        elsif user.able_to?(:view_feedbacks_in_city)
          location_ids = Location.select(:id).in_city(user.city).where.not(code: %w[archive done special]).pluck(:id)
          service_job_ids = ServiceJob.select(:id).where(location_id: location_ids).pluck(:id)
        else
          service_job_ids = ServiceJob.select(:id).where(location_id: user.location_id).pluck(:id)
        end
        scope.where(service_job_id: service_job_ids)
      end
    end
  end
end
