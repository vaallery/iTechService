class AddItemToStolenPhones < ActiveRecord::Migration
  def change
    add_reference :stolen_phones, :item, index: true, foreign_key: true
    change_column_null :stolen_phones, :imei, true
  end
end
