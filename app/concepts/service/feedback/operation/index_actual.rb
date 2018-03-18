module Service
  class Feedback::IndexActual < BaseOperation
    step :model!

    private

    def model!(options, current_user:, **)
      feedbacks = Feedback.actual

      if current_user.able_to_view_feedbacks?
        excluded_locations = Location.where(code: %w[archive done])
        service_job_ids = ServiceJob.select(:id).where.not(location: excluded_locations).pluck(:id)
      else
        service_job_ids = ServiceJob.select(:id).where(location_id: current_user.location_id).pluck(:id)
      end
      feedbacks = feedbacks.where(service_job_id: service_job_ids)

      options['model'] = feedbacks
    end
  end
end
