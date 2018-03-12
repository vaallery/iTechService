module Service
  class Feedback::IndexActual < BaseOperation
    step :model!

    private

    def model!(options, current_user:, **)
      feedbacks = Feedback.actual

      unless current_user.able_to_view_feedbacks?
        service_job_ids = ServiceJob.select(:id).where(location_id: current_user.location_id).pluck(:id)
        feedbacks = feedbacks.where(service_job_id: service_job_ids)
      end

      options['model'] = feedbacks
    end
  end
end
