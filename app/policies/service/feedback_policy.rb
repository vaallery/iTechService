module Service
  class FeedbackPolicy < BasePolicy
    def update?
      superadmin? || same_location? ||
        able_to?(:view_feedback_notifications) ||
        (same_city? && able_to?(:view_feedbacks_in_city))
    end

    def postpone?
      update?
    end

    class Scope < Scope
      def resolve
        if user.superadmin? || user.able_to?(:view_feedback_notifications)
          locations = Location.where.not(code: %w[archive done special])
        elsif user.able_to?(:view_feedbacks_in_city)
          locations = Location.in_city(user.city).where.not(code: %w[archive done special])
        else
          locations = user.location
        end
        scope.where(service_job_id: ServiceJob.located_at(locations))
      end
    end
  end
end
