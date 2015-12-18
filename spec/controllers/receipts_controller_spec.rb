require 'rails_helper'

RSpec.describe ReceiptsController, :type => :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #print" do
    it "returns http success" do
      get :print
      expect(response).to have_http_status(:success)
    end
  end

end
