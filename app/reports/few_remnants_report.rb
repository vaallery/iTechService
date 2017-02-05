class FewRemnantsReport < BaseReport
  attr_accessor :kind

  def name
    "#{super}_#{kind}"
  end

  def call
    result[:products] = result[:stores] = {}
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
      result[:products].store product.id.to_s, {code: product.code, name: product.name, threshold: product.quantity_threshold, remnants: remnants} unless remnants.empty?
    end
    result
  end
end