module DevicesHelper
  
  def class_for_task task
    task.done ? 'success' : 'warning'
  end
end
