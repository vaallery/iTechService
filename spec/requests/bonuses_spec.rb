require 'rails_helper'

RSpec.describe "Bonuses", :type => :request do
  describe "GET /bonuses" do
    it "works! (now write some real specs)" do
      get bonuses_path
      expect(response).to have_http_status(200)
    end
  end
end
