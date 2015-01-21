class CreateMediaOrders < ActiveRecord::Migration
  def change
    create_table :media_orders do |t|
      t.datetime :time
      t.string :name
      t.string :phone
      t.text :content

      t.timestamps
    end
  end
end
