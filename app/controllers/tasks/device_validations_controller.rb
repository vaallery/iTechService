module Tasks
  class DeviceValidationsController < ApplicationController
    def show
      task = Task.find_by(id: params[:task_id])
      item = Item.find_by(id: params[:item_id])

      if task && item && need_validation?(task)
        message = validate task, item
        render json: {message: message}
      else
        render json: {}
      end
    end

    private

    def need_validation?(task)
      return false unless tasks_models
      tasks_models.has_key? task.code
    end

    def validate(task, item)
      return t('settings.errors.not_found', name: 'service_tasks_models') unless tasks_models
      device_name = item.product_group_name
      task_code = task.code
      valid_model = tasks_models.dig(task_code, device_name)
      return t('service_jobs.tasks.device_model_not_found', task_name: task.name, device_name: device_name) unless valid_model
      t 'service_jobs.tasks.valid_device_model', task_name: task.name, device_name: device_name, model_name: valid_model
    end

    def tasks_models
      return @tasks_models if defined? @tasks_models
      @tasks_models = Setting.service_tasks_models
    end
  end
end
