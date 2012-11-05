require "spec_helper"

describe InvestmentAssetCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/investment_asset_categories").should route_to("investment_asset_categories#index")
    end

    it "routes to #new" do
      get("/investment_asset_categories/new").should route_to("investment_asset_categories#new")
    end

    it "routes to #show" do
      get("/investment_asset_categories/1").should route_to("investment_asset_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/investment_asset_categories/1/edit").should route_to("investment_asset_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/investment_asset_categories").should route_to("investment_asset_categories#create")
    end

    it "routes to #update" do
      put("/investment_asset_categories/1").should route_to("investment_asset_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/investment_asset_categories/1").should route_to("investment_asset_categories#destroy", :id => "1")
    end

  end
end
