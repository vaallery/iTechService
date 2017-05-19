class CreatePhoneSubstitutions < ActiveRecord::Migration
  def change
    create_table :phone_substitutions do |t|
      t.references :substitute_phone, null: false, index: true, foreign_key: true
      t.references :service_job, null: false, index: true, foreign_key: true
      t.references :issuer, null: false, index: true
      t.datetime :issued_at, null: false
      t.references :receiver, index: true#, foreign_key: {to_table: :users}
      t.boolean :condition_match
      t.datetime :withdrawn_at

      t.timestamps null: false
    end
    add_foreign_key :phone_substitutions, :users, column: :issuer_id
    add_foreign_key :phone_substitutions, :users, column: :receiver_id
  end
end
