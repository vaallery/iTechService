class AddImportantToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :important, :boolean, default: false
  end
end
