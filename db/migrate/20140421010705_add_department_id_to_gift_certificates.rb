class AddDepartmentIdToGiftCertificates < ActiveRecord::Migration
  def change
    add_column :gift_certificates, :department_id, :integer
    add_index :gift_certificates, :department_id
  end
end
