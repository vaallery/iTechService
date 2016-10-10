class CreateTaskTemplates < ActiveRecord::Migration
  def change
    create_table :task_templates do |t|
      t.text :content, null: false
      t.string :icon
      t.string :ancestry, index: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
