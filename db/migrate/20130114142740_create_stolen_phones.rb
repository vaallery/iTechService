class CreateStolenPhones < ActiveRecord::Migration
  def change
    create_table :stolen_phones do |t|
      t.string :imei, null: false
      t.text :comment

      t.timestamps
    end
    add_index :stolen_phones, :imei
  end
end
