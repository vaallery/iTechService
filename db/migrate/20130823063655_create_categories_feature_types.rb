class CreateCategoriesFeatureTypes < ActiveRecord::Migration
  def change
    create_table :categories_feature_types do |t|
      t.belongs_to :category
      t.belongs_to :feature_type
    end
  end
end
