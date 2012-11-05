require 'spec_helper'

describe "investment_asset_categories/index.html.erb" do
  before(:each) do
    assign(:investment_asset_categories, [
      stub_model(InvestmentAssetCategory,
        :name => "Name",
        :key => "Key"
      ),
      stub_model(InvestmentAssetCategory,
        :name => "Name",
        :key => "Key"
      )
    ])
  end

  it "renders a list of investment_asset_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Key".to_s, :count => 2
  end
end
