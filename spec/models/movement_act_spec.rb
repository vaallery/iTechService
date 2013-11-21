require 'spec_helper'

describe MovementAct do

  it { should belong_to :user }
  it { should belong_to :store }
  it { should belong_to :dst_store }
  it { should have_many :movement_items }
  it { should accept_nested_attributes_for :movement_items }
  it { should validate_presence_of :date }
  it { should validate_presence_of :store }
  it { should validate_presence_of :dst_store }
  it { should validate_presence_of :status }
  it { should validate_presence_of :user }
  it { should ensure_inclusion_of(:status).in_array(Document::STATUSES) }

  it 'should be valid with valid attributes' do
    movement_act = build :movement_act
    movement_act.should be_valid
  end

  context 'validation' do

    it 'should not be valid if stores are same' do
      store = create :store
      movement_act = build :movement_act, store_id: store.id, dst_store_id: store.id
      expect(movement_act).to_not be_valid
    end

  end

  context 'posting' do

    before :each do
      @src_store = create :store
      @dst_store = create :store
      @movement_act = create :movement_act, store: @src_store, dst_store: @dst_store
    end

    it 'should change store_items` quantity on post' do
      item = create :item
      StoreItem.create store_id: @src_store.id, item_id: item.id, quantity: 5
      @movement_act.movement_items.create item_id: item.id, quantity: 2
      @movement_act.post
      @movement_act.status.should eq 1
      item.quantity_in_store(@src_store).should eq 3
      item.quantity_in_store(@dst_store).should eq 2
    end

    it 'should change store of featured store_item on post' do
      item = create :featured_item
      StoreItem.create store_id: @src_store.id, item_id: item.id, quantity: 1
      @movement_act.movement_items.create item_id: item.id, quantity: 1
      @movement_act.post
      @movement_act.status.should eq 1
      item.store_item.store.should eq @dst_store
    end

  end

end
