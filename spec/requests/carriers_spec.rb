require 'rails_helper'

RSpec.describe "Carriers", :type => :request do
  describe "GET /carriers" do
    it "works! (now write some real specs)" do
      get carriers_path
      expect(response).to have_http_status(200)
    end
  end
end
