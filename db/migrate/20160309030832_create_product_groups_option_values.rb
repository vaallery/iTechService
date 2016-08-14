class CreateProductGroupsOptionValues < ActiveRecord::Migration
  def change
    create_table :product_groups_option_values, id: false do |t|
      t.references :product_group, index: true, foreign_key: true
      t.references :option_value, index: true, foreign_key: true
    end
  end
end
