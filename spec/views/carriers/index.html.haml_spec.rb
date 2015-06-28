require 'rails_helper'

RSpec.describe "carriers/index", :type => :view do
  before(:each) do
    assign(:carriers, [
      Carrier.create!(
        :name => "Name"
      ),
      Carrier.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of carriers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
