class AddArchivedToSubstitutePhones < ActiveRecord::Migration
  def change
    add_column :substitute_phones, :archived, :boolean
  end
end
