class CreateSupplyReports < ActiveRecord::Migration
  def change
    create_table :supply_reports do |t|
      t.date :date

      t.timestamps
    end
  end
end
