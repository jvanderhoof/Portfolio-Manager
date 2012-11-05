require 'spec_helper'

describe "investment_assets/edit.html.erb" do
  before(:each) do
    @investment_asset = assign(:investment_asset, stub_model(InvestmentAsset))
  end

  it "renders the edit investment_asset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => investment_assets_path(@investment_asset), :method => "post" do
    end
  end
end
