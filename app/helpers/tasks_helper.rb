module TasksHelper

  def available_tasks_for user
    if user.admin?
      Task.all
    else
      Task.allowed_for user
    end
  end

end
