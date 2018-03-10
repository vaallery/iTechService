module Service
  class Feedback::IndexActual < BaseOperation
    step :model!

    private

    def model!(options, current_user:, **)
      service_job_ids = ServiceJob.select(:id).where(location_id: current_user.location_id).pluck(:id)
      feedbacks = Feedback.where(service_job_id: service_job_ids).where('scheduled_on <= ?', Time.current)
      options['model'] = feedbacks
    end
  end
end
