class AddIndexOnBarcodeNumInItems < ActiveRecord::Migration
  def change
    add_index :items, :barcode_num
  end
end
