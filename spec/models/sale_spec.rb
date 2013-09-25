require 'spec_helper'

describe Sale do

  it 'is valid with valid attributes' do
    sale = build :sale
    expect(sale).to be_valid
  end

  context 'posting' do

    it 'should decrease quantity of products after posting' do
      sale = create :sale
    end

    it 'should restore quantity of products after unposting' do
      sale = create :sale
    end

  end

end
