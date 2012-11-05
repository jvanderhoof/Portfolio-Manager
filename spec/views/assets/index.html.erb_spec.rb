require 'spec_helper'

describe "assets/index.html.erb" do
  before(:each) do
    assign(:assets, [
      stub_model(Asset),
      stub_model(Asset)
    ])
  end

  it "renders a list of assets" do
    render
  end
end
