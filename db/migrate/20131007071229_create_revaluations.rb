class CreateRevaluations < ActiveRecord::Migration
  def change
    create_table :revaluations do |t|
      t.references :revaluation_act
      t.references :product
      t.decimal :price

      t.timestamps
    end
    add_index :revaluations, :revaluation_act_id
    add_index :revaluations, :product_id
  end
end
