class AddDepartmentIdToGiftCertificates < ActiveRecord::Migration
  class GiftCertificate < ActiveRecord::Base; end
  def up
    add_column :gift_certificates, :department_id, :integer
    add_index :gift_certificates, :department_id

    GiftCertificate.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end

  def down
    remove_index :gift_certificates, :department_id
    remove_column :gift_certificates, :department_id
  end
end
