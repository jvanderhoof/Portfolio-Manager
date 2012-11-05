require 'spec_helper'

describe "assets/edit.html.erb" do
  before(:each) do
    @asset = assign(:asset, stub_model(Asset))
  end

  it "renders the edit asset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => assets_path(@asset), :method => "post" do
    end
  end
end
