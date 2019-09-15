class CreateSparePartDefects < ActiveRecord::Migration
  def change
    create_table :spare_part_defects do |t|
      t.references :item, index: true, foreign_key: true
      t.references :contractor, index: true, foreign_key: true
      t.integer :qty, null: false

      t.timestamps null: false
    end
  end
end
