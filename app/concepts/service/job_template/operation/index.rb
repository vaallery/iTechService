module Service
  class JobTemplate::Index < BaseOperation
    step Policy::Pundit(JobTemplatePolicy, :index?)
    failure :not_authorized!

    step ->(options, params:, **) {
      job_templates = JobTemplate.filter(params).ordered
      options['model'] = job_templates
    }
  end
end
