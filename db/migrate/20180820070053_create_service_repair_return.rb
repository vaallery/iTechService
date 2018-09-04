class CreateServiceRepairReturn < ActiveRecord::Migration
  def change
    create_table :service_repair_returns do |t|
      t.references :service_job, null: false, index: true, foreign_key: true
      t.references :performer, null: false, index: true
      t.datetime :performed_at, null: false
    end

    add_foreign_key :service_repair_returns, :users, column: :performer_id
  end
end
