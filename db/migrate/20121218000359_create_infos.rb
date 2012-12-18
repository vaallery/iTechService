class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :infos, :title
  end
end
