class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options, id: false do |t|
      t.references :product, null: false, index: true, foreign_key: true
      t.references :option_value, null: false, index: true, foreign_key: true
    end
  end
end
