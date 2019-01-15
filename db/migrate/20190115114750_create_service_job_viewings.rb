class CreateServiceJobViewings < ActiveRecord::Migration
  def change
    create_table :service_job_viewings do |t|
      t.references :service_job, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.datetime :time, null: false, index: true
      t.string :ip, null: false

      t.timestamps null: false
    end
  end
end
