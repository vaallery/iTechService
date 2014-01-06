class CreateFeatureTypes < ActiveRecord::Migration
  def change
    create_table :feature_types do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :feature_types, :code
  end
end
