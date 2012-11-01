require 'spec_helper'

describe "devices/new" do
  before(:each) do
    assign(:device, stub_model(Device,
      :type => nil,
      :ticket_number => "MyString",
      :client => nil
    ).as_new_record)
  end

  it "renders new device form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => devices_path, :method => "post" do
      assert_select "input#device_type", :name => "device[type]"
      assert_select "input#device_ticket_number", :name => "device[ticket_number]"
      assert_select "input#device_client", :name => "device[client]"
    end
  end
end
