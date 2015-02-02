require 'rails_helper'

RSpec.describe "media_orders/index", :type => :view do
  before(:each) do
    assign(:media_orders, [
      MediaOrder.create!(
        :name => "Name",
        :phone => "Phone",
        :content => "MyText"
      ),
      MediaOrder.create!(
        :name => "Name",
        :phone => "Phone",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of media_orders" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
