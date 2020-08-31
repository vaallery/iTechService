class CreateRepairPrices < ActiveRecord::Migration
  def up
    create_table :repair_prices do |t|
      t.references :repair_service, index: true, foreign_key: true
      t.references :department, index: true, foreign_key: true
      t.decimal :value
      t.timestamps null: false
    end

    RepairService.find_each do |service|
      Department.real.each do |department|
        RepairPrice.create! repair_service_id: service.id,
                            department_id: department.id,
                            value: service['price']
      end
    end

    remove_column :repair_services, :price
  end

  def down
    add_column :repair_services, :price, :decimal

    RepairPrice.in_department(Department.default).find_each do |price|
      price.repair_service.update_column :price, price.value
    end

    drop_table :repair_prices
  end
end
