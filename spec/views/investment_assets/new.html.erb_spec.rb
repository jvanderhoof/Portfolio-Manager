require 'spec_helper'

describe "investment_assets/new.html.erb" do
  before(:each) do
    assign(:investment_asset, stub_model(InvestmentAsset).as_new_record)
  end

  it "renders new investment_asset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => investment_assets_path, :method => "post" do
    end
  end
end
