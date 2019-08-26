require 'rails_helper'

describe SalesImportJob do
  before do
    described_class.perform_now
  end

  it 'creates Imported Sales' do
    expect(ImportedSale.count).to be > 0
  end
end