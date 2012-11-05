require 'spec_helper'

describe "investment_assets/index.html.erb" do
  before(:each) do
    assign(:investment_assets, [
      stub_model(InvestmentAsset),
      stub_model(InvestmentAsset)
    ])
  end

  it "renders a list of investment_assets" do
    render
  end
end
