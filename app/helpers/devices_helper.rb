module DevicesHelper
  
  def class_for_task task
    task.done ? 'success' : 'warning'
  end
  
  def class_for_device device
    device.done? ? 'success' : 'warning'
  end
  
end
