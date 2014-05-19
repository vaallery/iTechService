class AddDepartmentIdToGiftCertificates < ActiveRecord::Migration
  class GiftCertificate < ActiveRecord::Base; end

  def change
    add_column :gift_certificates, :department_id, :integer
    add_index :gift_certificates, :department_id

    GiftCertificate.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
