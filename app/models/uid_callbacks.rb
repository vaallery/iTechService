class UidCallbacks
  def self.after_create(record)
    record.update_column :uid, "#{ENV['DEPARTMENT_CODE'] if record.class.name.in?(ENV['IMPORT_MODELS'].split)}#{record.id}"
    record.class.reflect_on_all_associations(:has_many).each do |reflection|
      if reflection.active_record_primary_key == :uid and !reflection.options.has_key?(:through)
        record.send(reflection.name).each do |r|
          r.update_column  reflection.foreign_key, record.uid
        end
      end
    end
  end

  def self.after_initialize(record)
    record.department_id ||= Department.current.respond_to?(:uid) ? Department.current.uid : Department.current.id if record.has_attribute? :department_id
  end
end