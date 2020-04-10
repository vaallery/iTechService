class AddDepartmentToMediaOrders < ActiveRecord::Migration
  class MediaOrder < ActiveRecord::Base; end

  def change
    add_reference :media_orders, :department, index: true, foreign_key: true

    reversible do |dir|
      dir.up do
        department_id = Department.default.id

        MediaOrder.where(department_id: nil).find_each do |media_order|
          media_order.update_column(:department_id, department_id)
        end

        change_column_null :media_orders, :department_id, false
      end
    end
  end
end
