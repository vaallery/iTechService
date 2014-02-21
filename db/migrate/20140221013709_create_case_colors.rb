class CreateCaseColors < ActiveRecord::Migration
  def change
    create_table :case_colors do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
