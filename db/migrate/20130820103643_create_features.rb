class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.references :feature_type
      t.references :product
      t.string :value

      t.timestamps
    end
    add_index :features, :feature_type_id
    add_index :features, :product_id
  end
end
