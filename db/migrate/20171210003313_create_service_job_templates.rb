class CreateServiceJobTemplates < ActiveRecord::Migration
  def change
    create_table :service_job_templates do |t|
      t.string :field_name, index: true
      t.string :content, null: false

      t.timestamps null: false
    end
  end
end
