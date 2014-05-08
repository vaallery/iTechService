class UidCallbacks
  def self.after_create(record)
    record.update_column :uid, "#{ENV['DEPARTMENT_CODE']}#{record.id}"
  end
end