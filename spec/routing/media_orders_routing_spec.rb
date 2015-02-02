require "rails_helper"

RSpec.describe MediaOrdersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/media_orders").to route_to("media_orders#index")
    end

    it "routes to #new" do
      expect(:get => "/media_orders/new").to route_to("media_orders#new")
    end

    it "routes to #show" do
      expect(:get => "/media_orders/1").to route_to("media_orders#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/media_orders/1/edit").to route_to("media_orders#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/media_orders").to route_to("media_orders#create")
    end

    it "routes to #update" do
      expect(:put => "/media_orders/1").to route_to("media_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/media_orders/1").to route_to("media_orders#destroy", :id => "1")
    end

  end
end
