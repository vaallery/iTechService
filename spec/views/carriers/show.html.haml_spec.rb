require 'rails_helper'

RSpec.describe "carriers/show", :type => :view do
  before(:each) do
    @carrier = assign(:carrier, Carrier.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
