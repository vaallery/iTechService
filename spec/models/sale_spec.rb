require 'spec_helper'

describe Sale do

  it 'is valid with valid attributes' do
    sale = build :sale
    expect(sale).to be_valid
  end

  it 'is valid with items' do
    sale = create :sale_with_items
    expect(sale).to be_valid
    expect(sale.sale_items.count).to be > 0
  end

  it 'is valid with featured items' do
    sale = create :sale_with_featured_items
    expect(sale).to be_valid
    expect(sale.sale_items.count).to be > 0
  end

  context 'posting' do

    it 'should decrease quantity of products without features after posting' do
      item = create :item
      store = create :store
      purchase = create :purchase, store_id: store.id, batches_attributes: {'1' => {item_id: item.id, price: 1000, quantity: 3}}
      purchase.post
      sale = create :sale, store_id: store.id, sale_items_attributes: {'1' => {item_id: item.id, price: 1000, quantity: 1}}
      sale.post
      expect(item.store_item(sale.store_id).quantity).to eq 2
    end

    it 'should decrease quantity of products with features after posting' do
      item = create(:featured_item)
      store = create :store
      purchase = create :purchase, store_id: store.id, batches_attributes: {'1' => {item_id: item.id, price: 1000, quantity: 1}}
      purchase.post
      sale = create :sale, store_id: store.id, sale_items_attributes: {'1' => {item_id: item.id, price: 1000, quantity: 1}}
      sale.post
      expect(item.store_item(sale.store_id).quantity).to eq 0
    end

    it 'should restore quantity of products after unposting' do
      sale = create :sale
    end

  end

end
