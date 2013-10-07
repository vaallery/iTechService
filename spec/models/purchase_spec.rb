require 'spec_helper'

describe Purchase do

  it 'is valid with valid attributes' do
    purchase = create :purchase
    expect(purchase).to be_true
  end

  context 'posting' do

    it 'should create "store_items" with valid quantity for products without features after posting' do
      item = create(:item)
      purchase = create :purchase, batches_attributes: {'1' => {item_id: item.id, price: 1000, quantity: 3}}
      purchase.post
      expect(item.store_items.count).to eq 1
      expect(item.store_items.in_store(purchase.store_id).count).to eq 1
      expect(item.store_items.in_store(purchase.store_id).first.quantity).to eq 3
    end

    it 'should create "store_items" with valid quantity for products with features after posting' do
      item = create(:featured_item)
      purchase = create :purchase, batches_attributes: {'1' => {item_id: item.id, price: 1000, quantity: 1}}
      purchase.post
      expect(item.store_items.count).to eq 1
      expect(item.store_items.in_store(purchase.store_id).count).to eq 1
      expect(item.store_items.in_store(purchase.store_id).first.quantity).to eq 1
    end

    it 'should create "product_prices" for products after posting' do
      item = create(:item)
      purchase = create :purchase, batches_attributes: {'1' => {item_id: item.id, price: 1000, quantity: 3}}
      purchase.post
      expect(item.prices.count).to eq 1
      expect(item.prices.first.value).to eq 1000
    end

  end

end
