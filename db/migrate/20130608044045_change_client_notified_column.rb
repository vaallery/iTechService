class ChangeClientNotifiedColumn < ActiveRecord::Migration
  def up
    change_column_default :devices, :client_notified, nil
  end

  def down
  end
end
