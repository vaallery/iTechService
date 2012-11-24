class HistoryObserver < ActiveRecord::Observer
  include DeviseHelper
  
  observe :device, :device_task
  
  def after_save model
    if model.is_a? Device
      tracked_attributes = %w[client_id device_task_ids comment]
    elsif model.is_a? DeviceTask
      tracked_attributes = %w[done comment device_id task_id]
    end
    
    unless (changed_attributes_keys = tracked_attributes & model.changed_attributes.keys).empty?
      changed_attributes_keys.each do |key|
        column_type = model.class.columns_hash[key].type
        old_value = model.new_record? ? nil : model.changed_attributes[key]
        new_value = model.attributes[key]
        history_record = HistoryRecord.new column_name: key, column_type: column_type, new_value: new_value,
            old_value: old_value, object: model, user: User.current
        history_record.save
      end
    end
    
  end
  
end
