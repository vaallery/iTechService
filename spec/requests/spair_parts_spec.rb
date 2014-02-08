require 'spec_helper'

describe "SpairParts" do
  describe "GET /spair_parts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get spair_parts_path
      response.status.should be(200)
    end
  end
end
