class ChangeEmeiToImeiInDevicesAndStolenPhones < ActiveRecord::Migration
  def up
    rename_column :devices, :emei, :imei
    add_index :devices, :imei
    rename_column :stolen_phones, :emei, :imei
    add_index :stolen_phones, :imei
    add_column :stolen_phones, :comment, :text
  end

  def down
  end
end
