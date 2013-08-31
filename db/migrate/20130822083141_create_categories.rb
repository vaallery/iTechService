class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :is_service, default: false
      t.boolean :request_price, default: false
      t.boolean :feature_accounting, default: false

      t.timestamps
    end
  end
end
