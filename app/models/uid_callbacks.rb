class UidCallbacks
  def self.after_create(record)
    record.update_column :uid, "#{ENV['DEPARTMENT_CODE'] if record.class.name.in?(ENV['IMPORT_MODELS'].split)}#{record.id}"
  end

  def self.after_initialize(record)
    record.department_id ||= Department.current.uid if record.has_attribute? :department_id
  end
end