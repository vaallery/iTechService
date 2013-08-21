require "spec_helper"

describe FeatureValuesController do
  describe "routing" do

    it "routes to #index" do
      get("/feature_values").should route_to("feature_values#index")
    end

    it "routes to #new" do
      get("/feature_values/new").should route_to("feature_values#new")
    end

    it "routes to #show" do
      get("/feature_values/1").should route_to("feature_values#show", :id => "1")
    end

    it "routes to #edit" do
      get("/feature_values/1/edit").should route_to("feature_values#edit", :id => "1")
    end

    it "routes to #create" do
      post("/feature_values").should route_to("feature_values#create")
    end

    it "routes to #update" do
      put("/feature_values/1").should route_to("feature_values#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/feature_values/1").should route_to("feature_values#destroy", :id => "1")
    end

  end
end
