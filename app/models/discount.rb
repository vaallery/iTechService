class Discount

  VALUES = {
      usual: {
          equipment: {value: 0, unit: '', margin: 500},
          accessory: {value: 0, unit: '', margin: 100},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 100, unit: '%', margin: 0},
          limit: 0
      },
      regular: {
          equipment: {value: 500, unit: 'r', margin: 500},
          accessory: {value: 10, unit: '%', margin: 100},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 100, unit: '%', margin: 0},
          limit: 150000
      },
      super: {
          equipment: {value: 1000, unit: 'r', margin: 500},
          accessory: {value: 20, unit: '%', margin: 100},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 100, unit: '%', margin: 0},
          limit: 700000
      },
      friend: {
          equipment: {value: 0, unit: '', margin: 0},
          accessory: {value: 0, unit: '', margin: 0},
          service:   {value: 0, unit: '', margin: 0},
          protector: {value: 100, unit: '%', margin: 0},
          limit: nil
      }
  }

  def self.available_for(client, item)
    client_category = client.present? ? client.category_s.to_sym : :usual
    if (product_category = item.product_category.kind.to_sym).present?
      value = VALUES[client_category][product_category][:value]
      unit = VALUES[client_category][product_category][:unit]
      margin = VALUES[client_category][product_category][:margin]
      purchase_price = item.purchase_price
      retail_price = item.retail_price
      if retail_price.present? and purchase_price.present?
        discount = unit == '%' ? retail_price * value.fdiv(100) : value
        discount = retail_price - purchase_price + margin if (retail_price-discount) < (purchase_price+margin) and product_category != :protector
      else
        discount = 0
      end
      return discount > 0 ? discount : 0
    else
      return 0
    end
  end

  def self.max_available_for(client, item)
    client_category = client.present? ? client.category_s.to_sym : :usual
    if (product_category = item.product_category.kind.to_sym).present?
      margin = VALUES[client_category][product_category][:margin]
      purchase_price = item.purchase_price
      retail_price = item.retail_price
      if product_category == :protector and retail_price.present?
        discount = retail_price
      else
        discount = (retail_price.present? and purchase_price.present?) ? retail_price - purchase_price + margin : 0
      end
      return discount > 0 ? discount : 0
    else
      return 0
    end
  end

end
