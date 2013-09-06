class Batch < ActiveRecord::Base

  belongs_to :purchase, inverse_of: :batches
  belongs_to :item, inverse_of: :batches
  attr_accessible :price, :quantity, :item_id

  #def features=(attributes)
  #  #errors.add :features, I18n.t('batches.errors.feature_exists')
  #  unless attributes.any? { |attr| Feature.exists? product_id: self.product_id, feature_type_id: attr[1]['id'], value: attr[1]['value'] }
  #    attributes.each do |attr|
  #      Feature.create product_id: self.product_id, feature_type_id: attr[1]['id'], value: attr[1]['value']
  #    end
  #  end
  #end



  def sum
    (price || 0) * (quantity || 0)
  end

end
