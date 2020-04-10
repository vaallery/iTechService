module Service
  class FeedbackPolicy < BasePolicy
    def update?
      (user.location_id == record.service_job.location_id) || user.able_to_view_feedbacks?
    end

    class Scope < Scope
      def resolve
        scope.in_department
      end
    end
  end
end
