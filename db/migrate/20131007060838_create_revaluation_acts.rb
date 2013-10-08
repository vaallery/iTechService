class CreateRevaluationActs < ActiveRecord::Migration
  def change
    create_table :revaluation_acts do |t|
      t.references :price_type
      t.datetime :date
      t.integer :status

      t.timestamps
    end
    add_index :revaluation_acts, :price_type_id
    add_index :revaluation_acts, :status
  end
end
