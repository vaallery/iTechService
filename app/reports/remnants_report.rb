class RemnantsReport < BaseReport
  attr_accessor :store_id

  def call
    result[:data] = []

    store = Store.find(store_id)
    store_items = StoreItem.includes(item: {product: :product_group}).in_store(store_id).available
    product_groups = ProductGroup.except_services.arrange
    result[:data] = nested_product_groups_remnants product_groups, store_items, store

    result
  end

  private

  def nested_product_groups_remnants(product_groups, store_items, store)
    product_groups.collect do |product_group, sub_product_groups|
      group_store_items = store_items.where('product_groups.id = ?', product_group.id)
      if (product_ids = group_store_items.collect{|si|si.product.id}).present?
        products = product_group.products.find(product_ids).collect do |product|
          product_store_items = store_items.where('products.id = ?', product.id)
          items = product_store_items.collect do |item|
            features = item.feature_accounting ? item.features_s : '---'
            {type: 'item', depth: product_group.depth+2, id: item.item_id, name: features, quantity: item.quantity, details: [], purchase_price: item.purchase_price.to_f, price: item.retail_price.to_f, sum: item.retail_price.to_f*item.quantity}
          end
          product_quantity = product_store_items.sum(:quantity)
          {type: 'product', depth: product_group.depth+1, id: product.id, name: "#{product.code} | #{product.name}", quantity: product_quantity, details: items, purchase_price: product.purchase_price.to_f, price: product.retail_price.to_f, sum: product.retail_price.to_f*product_quantity}
        end
      else
        products = []
      end
      group_quantity = store_items.where(product_groups: {id: product_group.subtree_ids}).sum(:quantity)
      {type: 'group', depth: product_group.depth, id: product_group.id, name: "#{product_group.code} | #{product_group.name}", quantity: group_quantity, details: nested_product_groups_remnants(sub_product_groups, store_items, store) + products}
    end
  end
end