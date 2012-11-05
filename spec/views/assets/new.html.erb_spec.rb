require 'spec_helper'

describe "assets/new.html.erb" do
  before(:each) do
    assign(:asset, stub_model(Asset).as_new_record)
  end

  it "renders new asset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => assets_path, :method => "post" do
    end
  end
end
