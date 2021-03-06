module RepairTasksHelper
  def repair_task_fields(repair_service)
    new_repair_task = RepairTask.new repair_service_id: repair_service.id, device_task_id: params[:device_task_id]
    form_for(DeviceTask.new, url: '') do |f|
      f.simple_fields_for(:repair_tasks, new_repair_task, child_index: Time.new.to_i) do |ff|
        return render('device_tasks/repair_task_fields', f: ff)
      end
    end
  end

  def repairer_options
    users = User.helps_in_repair.in_city(current_city).to_a
    users << current_user unless users.include?(current_user)
    users
  end
end
