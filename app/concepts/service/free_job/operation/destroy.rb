module Service
  class FreeJob::Destroy < BaseOperation
    step Model(FreeJob, :find_by)
    failure :record_not_found!
    step Policy.Pundit(FreeJob::Policy, :destroy?)
    failure :not_authorized!
    step ->(model:, **) { model.destroy }
    step ->(options, **) { options['result.message'] = I18n.t('service.free_job.destroyed') }
  end
end
