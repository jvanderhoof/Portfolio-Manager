require 'spec_helper'

describe "InvestmentAssetCategories" do
  describe "GET /investment_asset_categories" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get investment_asset_categories_path
      response.status.should be(200)
    end
  end
end
