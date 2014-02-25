class CreateFeatureTypesProductCategories < ActiveRecord::Migration
  def change
    create_table :feature_types_product_categories do |t|
      t.belongs_to :product_category
      t.belongs_to :feature_type
    end
  end
end
