class ChangeHistroyRecordObjectTypeValue < ActiveRecord::Migration
  class HistoryRecord < ActiveRecord::Base; end

  def up
    HistoryRecord.where(object_type: 'Device').find_each do |history_record|
      history_record.update! object_type: 'ServiceJob'
    end
  end

  def down
    HistoryRecord.where(object_type: 'ServiceJob').find_each do |history_record|
      history_record.update! object_type: 'Device'
    end
  end
end
