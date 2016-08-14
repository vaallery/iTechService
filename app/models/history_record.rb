class HistoryRecord < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :object, polymorphic: true
  attr_accessible :column_name, :column_type, :deleted_at, :new_value, :old_value, :user, :object
  
  scope :order_by_newest, ->{order('created_at desc')}
  scope :service_jobs, ->{where(object_type: 'ServiceJob')}
  scope :device_tasks, ->{where(object_type: 'DeviceTask')}
  scope :task_completions, ->{where(object_type: 'DeviceTask', column_name: 'done')}
  scope :movements, ->{service_jobs.where(column_name: 'location_id')}
  scope :movements_from, ->(location) { service_jobs.where(column_name: 'location_id', old_value: (location.is_a?(Location) ? location.id.to_s : location.to_s)) }
  scope :movements_to, ->(location) { service_jobs.where(column_name: 'location_id', new_value: (location.is_a?(Array) ? location.map{|l|l.to_s} : location.to_s)) }
  scope :movements_to_archive, ->{service_jobs.where(column_name: 'location_id', new_value: Location.archive.id.to_s)}
  scope :in_period, ->(period) { where(created_at: period) }
  scope :by_user, ->(user) { where(user_id: (user.is_a?(User) ? user.id : user.to_i)) }
  scope :service_jobs_movements, ->{service_jobs.movements}

  def user_name
    user.present? ? user.short_name : ''
  end

end
