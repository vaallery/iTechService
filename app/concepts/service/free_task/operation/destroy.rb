module Service
  class FreeTask::Destroy < BaseOperation
    step Model(FreeTask, :find_by)
    failure :record_not_found!
    step Policy.Pundit(FreeTaskPolicy, :destroy?)
    failure :not_authorized!
    step ->(model:, **) { model.destroy }
    step ->(options, **) { options['result.message'] = I18n.t('service.free_task.destroyed') }
  end
end
