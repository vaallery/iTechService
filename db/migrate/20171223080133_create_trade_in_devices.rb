class CreateTradeInDevices < ActiveRecord::Migration
  def change
    create_table :trade_in_devices do |t|
      t.integer :number, null: false
      t.datetime :received_at, null: false
      t.references :item, null: false, index: true, foreign_key: true
      t.references :receiver, index: true
      t.integer :appraised_value, null: false
      t.string :appraiser, null: false
      t.string :bought_device, null: false
      t.string :client_name, null: false
      t.string :client_phone, null: false
      t.string :check_icloud, null: false
      t.integer :replacement_status
      t.boolean :archived, null: false, default: false
      t.text :archiving_comment

      t.timestamps null: false
    end

    add_foreign_key :trade_in_devices, :users, column: :receiver_id
  end
end
