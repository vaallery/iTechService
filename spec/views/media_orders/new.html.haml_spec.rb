require 'rails_helper'

RSpec.describe "media_orders/new", :type => :view do
  before(:each) do
    assign(:media_order, MediaOrder.new(
      :name => "MyString",
      :phone => "MyString",
      :content => "MyText"
    ))
  end

  it "renders new media_order form" do
    render

    assert_select "form[action=?][method=?]", media_orders_path, "post" do

      assert_select "input#media_order_name[name=?]", "media_order[name]"

      assert_select "input#media_order_phone[name=?]", "media_order[phone]"

      assert_select "textarea#media_order_content[name=?]", "media_order[content]"
    end
  end
end
