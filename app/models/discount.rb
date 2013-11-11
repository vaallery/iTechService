class Discount# < ActiveRecord::Base

  VALUES = {
      usual: {
          equipment: {value: 0, unit: '', margin: 500},
          accessory: {value: 0, unit: '', margin: 100},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 0, unit: '', margin: 0}
      },
      regular: {
          equipment: {value: 500, unit: 'r', margin: 500},
          accessory: {value: 10, unit: '%', margin: 100},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 0, unit: '', margin: 0}
      },
      super: {
          equipment: {value: 1000, unit: 'r', margin: 500},
          accessory: {value: 20, unit: '%', margin: 100},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 0, unit: '', margin: 0}
      },
      friend: {
          equipment: {value: 0, unit: '', margin: 0},
          accessory: {value: 0, unit: '', margin: 0},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 0, unit: '', margin: 0}
      }
  }

  #attr_accessible :limit, :value

  def initialize(client, product)
    if (client_category = client.category_s.to_sym).present? and (product_category = product.product_category.kind.to_sym).present?
      value = VALUES[client_category][product_category][:value]
      unit = VALUES[client_category][product_category][:unit]
      margin = VALUES[client_category][product_category][:margin]
    end
  end

  def self.available_for(client, item)
    if (client_category = client.category_s.to_sym).present? and (product_category = item.product_category.kind.to_sym).present?
      value = VALUES[client_category][product_category][:value]
      unit = VALUES[client_category][product_category][:unit]
      margin = VALUES[client_category][product_category][:margin]
      purchase_price = item.purchase_price
      retail_price = item.retail_price
      discount = unit == '%' ? retail_price * value.fdiv(100) : value
      discount = retail_price - purchase_price + margin if (retail_price-discount) < (purchase_price+margin)
      return discount
    end
  end

  def self.max_available_for(client, product)

  end

end
