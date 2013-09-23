class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name
      t.boolean :feature_accounting, default: false

      t.timestamps
    end
  end
end
