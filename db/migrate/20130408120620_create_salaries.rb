class CreateSalaries < ActiveRecord::Migration
  def change
    create_table :salaries do |t|
      t.references :user
      t.integer :amount

      t.timestamps
    end
    add_index :salaries, :user_id
  end
end
