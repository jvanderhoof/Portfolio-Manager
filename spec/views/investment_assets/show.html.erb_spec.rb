require 'spec_helper'

describe "investment_assets/show.html.erb" do
  before(:each) do
    @investment_asset = assign(:investment_asset, stub_model(InvestmentAsset))
  end

  it "renders attributes in <p>" do
    render
  end
end
