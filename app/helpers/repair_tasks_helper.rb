module RepairTasksHelper
  def repair_task_fields(repair_service)
    new_repair_task = RepairTask.new repair_service_id: repair_service.id
    form_for(DeviceTask.new, url: '') { |f| f.simple_fields_for(:repair_tasks, new_repair_task, child_index: Time.new.to_i) { |ff| return render('device_tasks/repair_task_fields', f: ff) } }
  end

  def repairer_options
    User.located_at(Location.repair_mac_or_ios.in_department(current_department))
  end
end
