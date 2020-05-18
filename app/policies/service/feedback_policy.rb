module Service
  class FeedbackPolicy < BasePolicy
    def update?
      (user.location_id == record.service_job.location_id) || superadmin? || able_to?(:view_feedback_notifications)
    end

    class Scope < Scope
      def resolve
        if user.superadmin? || user.able_to?(:view_feedback_notifications)
          location = Location.where.not(code: %w[archive done special])
        elsif user.able_to?(:view_feedbacks_in_city)
          location = Location.in_city(user.city).where.not(code: %w[archive done special])
        else
          location = user.location
        end
        scope.where(service_job_id: ServiceJob.located_at(location))
      end
    end
  end
end
