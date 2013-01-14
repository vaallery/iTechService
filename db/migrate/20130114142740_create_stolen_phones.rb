class CreateStolenPhones < ActiveRecord::Migration
  def change
    create_table :stolen_phones do |t|
      t.string :emei, null: false

      t.timestamps
    end
  end
end
