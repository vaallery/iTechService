require 'spec_helper'

describe Item do

  it 'is valid with valid attributes' do
    item = build :item
    expect(item).to be_valid
  end

  context 'feature accounting' do

    it 'is valid with valid attributes' do
      item = build :item, :feature_accounted
      expect(item).to be_valid
    end

  end

end
