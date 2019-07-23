class AddSkipRevaluationToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :skip_revaluation, :boolean
  end
end
