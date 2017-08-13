class AddPrinterToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :printer, :string
  end
end
