require "spec_helper"

describe InvestmentAssetsController do
  describe "routing" do

    it "routes to #index" do
      get("/investment_assets").should route_to("investment_assets#index")
    end

    it "routes to #new" do
      get("/investment_assets/new").should route_to("investment_assets#new")
    end

    it "routes to #show" do
      get("/investment_assets/1").should route_to("investment_assets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/investment_assets/1/edit").should route_to("investment_assets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/investment_assets").should route_to("investment_assets#create")
    end

    it "routes to #update" do
      put("/investment_assets/1").should route_to("investment_assets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/investment_assets/1").should route_to("investment_assets#destroy", :id => "1")
    end

  end
end
