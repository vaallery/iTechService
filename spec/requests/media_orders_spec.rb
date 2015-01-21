require 'rails_helper'

RSpec.describe "MediaOrders", :type => :request do
  describe "GET /media_orders" do
    it "works! (now write some real specs)" do
      get media_orders_path
      expect(response).to have_http_status(200)
    end
  end
end
