require 'rails_helper'

RSpec.describe "carriers/edit", :type => :view do
  before(:each) do
    @carrier = assign(:carrier, Carrier.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit carrier form" do
    render

    assert_select "form[action=?][method=?]", carrier_path(@carrier), "post" do

      assert_select "input#carrier_name[name=?]", "carrier[name]"
    end
  end
end
