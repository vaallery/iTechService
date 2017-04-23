class CreateSubstitutePhones < ActiveRecord::Migration
  def change
    create_table :substitute_phones do |t|
      t.references :item, index: true, foreign_key: true
      t.text :condition, null: false
      t.references :service_job, index: {unique: true}, foreign_key: true

      t.timestamps null: false
    end
  end
end
