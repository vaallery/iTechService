module DevicesHelper
  
  def row_class_for_task task
    task.done ? 'success' : task.is_important? ? 'error' : 'warning'
  end
  
  def row_class_for_device device
    device.done? ? 'success' : device.is_important? ? 'error' : 'warning'
  end
  
end
