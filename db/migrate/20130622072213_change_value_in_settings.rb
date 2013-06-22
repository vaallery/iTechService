class ChangeValueInSettings < ActiveRecord::Migration
  def up
    change_column :settings, :value, :text
  end

  def down
  end
end
