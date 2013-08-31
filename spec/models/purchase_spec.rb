require 'spec_helper'

describe Purchase do

  context 'callbacks' do

    it 'should create "stock_items" for products after posting' do
      product = create(:product)
      contractor = create(:contractor)
      store = create(:store)
      purchase = Purchase.create(contractor_id: contractor.id, store_id: store.id, batches_attributes: {'1' => {product_id: product.id, price: 1000, quantity: 3}})
      #purchase.save
      expect(product.stock_items.count).to be 1
      expect(product.stock_items.where(store_id: purchase.store_id).count).to be 1
      expect(product.stock_items.where(store_id: purchase.store_id).first.quantity).to be 3
    end

  end

end
