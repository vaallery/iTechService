require "spec_helper"

describe BonusController do
  describe "routing" do

    it "routes to #index" do
      get("/bonus").should route_to("bonus#index")
    end

    it "routes to #new" do
      get("/bonus/new").should route_to("bonus#new")
    end

    it "routes to #show" do
      get("/bonus/1").should route_to("bonus#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bonus/1/edit").should route_to("bonus#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bonus").should route_to("bonus#create")
    end

    it "routes to #update" do
      put("/bonus/1").should route_to("bonus#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bonus/1").should route_to("bonus#destroy", :id => "1")
    end

  end
end
