class CreateBonuses < ActiveRecord::Migration
  def change
    create_table :bonuses do |t|
      t.references :bonus_type
      t.text :comment

      t.timestamps
    end
    add_index :bonuses, :bonus_type_id
  end
end
