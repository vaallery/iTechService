class CreateClientCategories < ActiveRecord::Migration
  def change
    create_table :client_categories do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
