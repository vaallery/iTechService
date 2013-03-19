class CreateGiftCertificates < ActiveRecord::Migration
  def change
    create_table :gift_certificates do |t|
      t.string :number
      t.integer :nominal
      t.integer :status

      t.timestamps
    end

    add_index :gift_certificates, :number
  end
end
