class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :duration
      t.decimal :cost

      t.timestamps
    end
  end
end
