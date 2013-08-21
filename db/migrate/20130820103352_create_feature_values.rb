class CreateFeatureValues < ActiveRecord::Migration
  def change
    create_table :feature_values do |t|
      t.references :feature_type
      t.string :name

      t.timestamps
    end
    add_index :feature_values, :feature_type_id
  end
end
