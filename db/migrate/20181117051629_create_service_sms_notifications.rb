class CreateServiceSmsNotifications < ActiveRecord::Migration
  def change
    create_table :service_sms_notifications do |t|
      t.references :sender, null: false, index: true
      t.datetime :sent_at, null: false
      t.text :message, null: false
      t.string :phone_number, null: false

      t.timestamps null: false
    end

    add_foreign_key :service_sms_notifications, :users, column: :sender_id
  end
end
