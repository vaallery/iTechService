require "spec_helper"

describe RevaluationsController do
  describe "routing" do

    it "routes to #index" do
      get("/revaluations").should route_to("revaluations#index")
    end

    it "routes to #new" do
      get("/revaluations/new").should route_to("revaluations#new")
    end

    it "routes to #show" do
      get("/revaluations/1").should route_to("revaluations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/revaluations/1/edit").should route_to("revaluations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/revaluations").should route_to("revaluations#create")
    end

    it "routes to #update" do
      put("/revaluations/1").should route_to("revaluations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/revaluations/1").should route_to("revaluations#destroy", :id => "1")
    end

  end
end
