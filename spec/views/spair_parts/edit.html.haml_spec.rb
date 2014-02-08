require 'spec_helper'

describe "spair_parts/edit" do
  before(:each) do
    @spair_part = assign(:spair_part, stub_model(SpairPart,
      :repair_service => nil,
      :item => nil,
      :quantity => 1,
      :warranty_term => 1
    ))
  end

  it "renders the edit spair_part form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spair_part_path(@spair_part), "post" do
      assert_select "input#spair_part_repair_service[name=?]", "spair_part[repair_service]"
      assert_select "input#spair_part_item[name=?]", "spair_part[item]"
      assert_select "input#spair_part_quantity[name=?]", "spair_part[quantity]"
      assert_select "input#spair_part_warranty_term[name=?]", "spair_part[warranty_term]"
    end
  end
end
