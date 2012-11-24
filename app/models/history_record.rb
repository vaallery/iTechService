class HistoryRecord < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :object, polymorphic: true
  attr_accessible :column_name, :column_type, :deleted_at, :new_value, :old_value, :user, :object
  
  default_scope order('created_at desc')
  
end