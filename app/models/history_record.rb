class HistoryRecord < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :object, polymorphic: true
  attr_accessible :column_name, :column_type, :deleted_at, :new_value, :old_value, :user, :object
  
  default_scope order('created_at desc')
  scope :devices, where(object_type: 'Device')
  scope :movements_to_archive, where(column_name: 'location_id', new_value: Location.archive_id.to_s)
  scope :in_period, lambda {|period| where(created_at: period)}
  
end