module Service
  class JobTemplate::Destroy < BaseOperation
    step Model(JobTemplate, :find_by)
    failure :record_not_found!
    step Policy.Pundit(JobTemplate::Policy, :destroy?)
    failure :not_authorized!
    step ->(*, model:, **) { model.destroy }
    step ->(options, **) { options['result.message'] = I18n.t('service/job_template.destroyed') }
  end
end
