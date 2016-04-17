class CreateFavoriteLinks < ActiveRecord::Migration
  def change
    create_table :favorite_links do |t|
      t.references :owner, null: false, index: true
      t.string :name
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
