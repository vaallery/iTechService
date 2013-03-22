class AddConsumedToGiftCertificates < ActiveRecord::Migration
  def change
    add_column :gift_certificates, :consumed, :integer
  end
end
