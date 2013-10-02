require 'spec_helper'

describe Sale do

  it 'is valid with valid attributes' do
    sale = build :sale
    expect(sale).to be_valid
  end

  context 'posting' do

    it 'should decrease quantity of products without features after posting' do
      sale = create :sale
    end

    it 'should decrease quantity of products with features after posting' do
      sale = create :sale
    end

    it 'should restore quantity of products after unposting' do
      sale = create :sale
    end

  end

end
