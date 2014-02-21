class CreateQuickTasks < ActiveRecord::Migration
  def change
    create_table :quick_tasks do |t|
      t.string :name

      t.timestamps
    end
  end
end
