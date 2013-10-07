require 'spec_helper'

describe Item do

  it 'is valid with valid attributes' do
    item = build :item
    expect(item).to be_valid
  end

  context 'feature accounting' do

    it 'is valid with valid attributes' do
      item = create :featured_item
      expect(item).to be_valid
      expect(item.feature_accounting).to be_true
    end

  end

end
