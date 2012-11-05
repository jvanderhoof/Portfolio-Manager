require 'spec_helper'

describe "investment_asset_categories/show.html.erb" do
  before(:each) do
    @investment_asset_category = assign(:investment_asset_category, stub_model(InvestmentAssetCategory,
      :name => "Name",
      :key => "Key"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Key/)
  end
end
