class RenameCodeToKindInFeatureTypes < ActiveRecord::Migration
  def change
    rename_column :feature_types, :code, :kind
  end
end
