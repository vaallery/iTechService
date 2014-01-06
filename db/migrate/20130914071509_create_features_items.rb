class CreateFeaturesItems < ActiveRecord::Migration
  def change
    create_table :features_items do |t|
      t.references :feature
      t.references :item
    end
  end
end
