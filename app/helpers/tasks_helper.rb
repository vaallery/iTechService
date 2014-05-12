module TasksHelper

  def available_tasks_for user
    if user.admin?
      Task.all
    else
      Task.allowed_for user
    end
  end

  def service_products_collection
    Product.services.all.map{|p| ["#{p.name} [#{p.code}]", p.uid]}
  end

  def locations_collection
    Location.all.map{|l|[l.name, l.uid]}
  end

end
