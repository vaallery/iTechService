require "rails_helper"

RSpec.describe CarriersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/carriers").to route_to("carriers#index")
    end

    it "routes to #new" do
      expect(:get => "/carriers/new").to route_to("carriers#new")
    end

    it "routes to #show" do
      expect(:get => "/carriers/1").to route_to("carriers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/carriers/1/edit").to route_to("carriers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/carriers").to route_to("carriers#create")
    end

    it "routes to #update" do
      expect(:put => "/carriers/1").to route_to("carriers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/carriers/1").to route_to("carriers#destroy", :id => "1")
    end

  end
end
