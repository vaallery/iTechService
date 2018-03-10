class CreateServiceFeedbacks < ActiveRecord::Migration
  def change
    create_table :service_feedbacks do |t|
      t.references :service_job, index: true, foreign_key: true, null: false
      t.datetime :scheduled_on
      t.integer :postpone_count, null: false, default: 0
      t.text :details

      t.timestamps null: false
    end
  end
end
