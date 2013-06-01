class AddIssuedAtToSalaries < ActiveRecord::Migration
  def change
    add_column :salaries, :issued_at, :datetime
  end
end
