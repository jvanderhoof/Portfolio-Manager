require 'spec_helper'

describe "investment_asset_categories/edit.html.erb" do
  before(:each) do
    @investment_asset_category = assign(:investment_asset_category, stub_model(InvestmentAssetCategory,
      :name => "MyString",
      :key => "MyString"
    ))
  end

  it "renders the edit investment_asset_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => investment_asset_categories_path(@investment_asset_category), :method => "post" do
      assert_select "input#investment_asset_category_name", :name => "investment_asset_category[name]"
      assert_select "input#investment_asset_category_key", :name => "investment_asset_category[key]"
    end
  end
end
