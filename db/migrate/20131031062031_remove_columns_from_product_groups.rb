class RemoveColumnsFromProductGroups < ActiveRecord::Migration
  def up
    remove_columns :product_groups, :is_service, :request_price
  end

  def down
  end
end
