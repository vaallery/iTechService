require 'rails_helper'

RSpec.describe "media_orders/show", :type => :view do
  before(:each) do
    @media_order = assign(:media_order, MediaOrder.create!(
      :name => "Name",
      :phone => "Phone",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/MyText/)
  end
end
