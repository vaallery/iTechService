class HistoryRecord < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :object, polymorphic: true
  attr_accessible :column_name, :column_type, :deleted_at, :new_value, :old_value, :user, :object
  
  default_scope order('created_at desc')
  scope :devices, where(object_type: 'Device')
  scope :device_tasks, where(object_type: 'DeviceTask')
  scope :task_completions, where(object_type: 'DeviceTask', column_name: 'done')
  scope :movements, where(column_name: 'location_id')
  scope :movements_to, lambda { |location| where(column_name: 'location_id', new_value: (location.is_a?(Location) ? location.id : location)) }
  scope :movements_to_archive, where(column_name: 'location_id', new_value: Location.archive_id.to_s)
  scope :in_period, lambda {|period| where(created_at: period)}

  def user_name
    user.present? ? user.short_name : ''
  end
  
end