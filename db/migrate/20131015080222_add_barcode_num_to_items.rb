class AddBarcodeNumToItems < ActiveRecord::Migration
  def change
    add_column :items, :barcode_num, :integer
  end
end
