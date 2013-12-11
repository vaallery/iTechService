class CreateKarmaGroups < ActiveRecord::Migration
  def change
    create_table :karma_groups do |t|
      t.references :bonus

      t.timestamps
    end
    add_index :karma_groups, :bonus_id
  end
end
