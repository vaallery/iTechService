class CreateLostDevices < ActiveRecord::Migration
  def change
    create_table :lost_devices do |t|
      t.references :service_job, index: {unique: true}, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
