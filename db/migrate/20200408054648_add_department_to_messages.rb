class AddDepartmentToMessages < ActiveRecord::Migration
  class Message < ActiveRecord::Base; end

  def change
    add_reference :messages, :department, index: true, foreign_key: true

    reversible do |dir|
      dir.up do
        department_id = Department.default.id

        Message.where(department_id: nil).find_each do |message|
          message.update_column(:department_id, department_id)
        end

        change_column_null :messages, :department_id, false
      end
    end
  end
end
