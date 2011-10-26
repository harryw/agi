require "spec_helper"

describe DatabasesController do
  describe "routing" do

    it "routes to #index" do
      get("/databases").should route_to("databases#index")
    end

    it "routes to #new" do
      get("/databases/new").should route_to("databases#new")
    end

    it "routes to #show" do
      get("/databases/1").should route_to("databases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/databases/1/edit").should route_to("databases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/databases").should route_to("databases#create")
    end

    it "routes to #update" do
      put("/databases/1").should route_to("databases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/databases/1").should route_to("databases#destroy", :id => "1")
    end

  end
end
