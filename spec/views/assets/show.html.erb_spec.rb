require 'spec_helper'

describe "assets/show.html.erb" do
  before(:each) do
    @asset = assign(:asset, stub_model(Asset))
  end

  it "renders attributes in <p>" do
    render
  end
end
