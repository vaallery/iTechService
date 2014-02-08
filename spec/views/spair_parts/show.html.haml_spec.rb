require 'spec_helper'

describe "spair_parts/show" do
  before(:each) do
    @spair_part = assign(:spair_part, stub_model(SpairPart,
      :repair_service => nil,
      :item => nil,
      :quantity => 1,
      :warranty_term => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
