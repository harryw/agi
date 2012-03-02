require "spec_helper"

describe ChefAccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/chef_accounts").should route_to("chef_accounts#index")
    end

    it "routes to #new" do
      get("/chef_accounts/new").should route_to("chef_accounts#new")
    end

    it "routes to #show" do
      get("/chef_accounts/1").should route_to("chef_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/chef_accounts/1/edit").should route_to("chef_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/chef_accounts").should route_to("chef_accounts#create")
    end

    it "routes to #update" do
      put("/chef_accounts/1").should route_to("chef_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/chef_accounts/1").should route_to("chef_accounts#destroy", :id => "1")
    end

  end
end
