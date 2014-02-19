module Report

  def self.few_remnants(kind)
    result = {products: {}, stores: {}}
    products = Product.send(kind)
    stores = Store.send(kind == :goods ? :retail : :spare_parts).order('id asc')
    stores.each { |store| result[:stores].store store.id.to_s, {code: store.code, name: store.name} }
    products.each do |product|
      remnants = {}
      stores.each do |store|
        if product.quantity_threshold.present? and (qty = product.quantity_in_store(store)) <= product.quantity_threshold
          remnants.store store.id.to_s, qty
        end
      end
      result[:products].store product.id.to_s, {code: product.code, name: product.name, remnants: remnants} unless remnants.empty?
    end
    result
  end

end