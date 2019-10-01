class AddRepairPartToSparePartDefects < ActiveRecord::Migration
  def change
    add_reference :spare_part_defects, :repair_part, index: true, foreign_key: true
    add_column :spare_part_defects, :is_warranty, :boolean, null: false, default: false
  end
end
