require "spec_helper"

describe SpairPartsController do
  describe "routing" do

    it "routes to #index" do
      get("/spair_parts").should route_to("spair_parts#index")
    end

    it "routes to #new" do
      get("/spair_parts/new").should route_to("spair_parts#new")
    end

    it "routes to #show" do
      get("/spair_parts/1").should route_to("spair_parts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/spair_parts/1/edit").should route_to("spair_parts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/spair_parts").should route_to("spair_parts#create")
    end

    it "routes to #update" do
      put("/spair_parts/1").should route_to("spair_parts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/spair_parts/1").should route_to("spair_parts#destroy", :id => "1")
    end

  end
end
