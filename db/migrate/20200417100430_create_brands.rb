class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :logo

      t.timestamps null: false
    end
  end
end
