module RepairTasksHelper

  def repair_task_fields(repair_service)
    new_repair_task = RepairTask.new repair_service_id: repair_service.id
    repair_service.spare_parts.each { |spare_part| new_repair_task.repair_parts.build(item_id: spare_part.product.item.id, quantity: spare_part.quantity) }
    form_for(DeviceTask.new, url: '') { |f| f.simple_fields_for(:repair_tasks, new_repair_task, child_index: Time.new.to_i) { |ff| return render('device_tasks/repair_task_fields', f: ff) } }
  end

end
