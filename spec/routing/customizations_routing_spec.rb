require "spec_helper"

describe CustomizationsController do
  describe "routing" do

    it "routes to #index" do
      get("/customizations").should route_to("customizations#index")
    end

    it "routes to #new" do
      get("/customizations/new").should route_to("customizations#new")
    end

    it "routes to #show" do
      get("/customizations/1").should route_to("customizations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/customizations/1/edit").should route_to("customizations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/customizations").should route_to("customizations#create")
    end

    it "routes to #update" do
      put("/customizations/1").should route_to("customizations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/customizations/1").should route_to("customizations#destroy", :id => "1")
    end

  end
end
