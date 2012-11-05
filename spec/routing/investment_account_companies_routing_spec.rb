require "spec_helper"

describe InvestmentAccountCompaniesController do
  describe "routing" do

    it "routes to #index" do
      get("/investment_account_companies").should route_to("investment_account_companies#index")
    end

    it "routes to #new" do
      get("/investment_account_companies/new").should route_to("investment_account_companies#new")
    end

    it "routes to #show" do
      get("/investment_account_companies/1").should route_to("investment_account_companies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/investment_account_companies/1/edit").should route_to("investment_account_companies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/investment_account_companies").should route_to("investment_account_companies#create")
    end

    it "routes to #update" do
      put("/investment_account_companies/1").should route_to("investment_account_companies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/investment_account_companies/1").should route_to("investment_account_companies#destroy", :id => "1")
    end

  end
end
