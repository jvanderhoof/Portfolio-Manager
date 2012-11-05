require 'spec_helper'

describe "investment_account_companies/index.html.erb" do
  before(:each) do
    assign(:investment_account_companies, [
      stub_model(InvestmentAccountCompany,
        :investment_account_id => 1,
        :name => "Name"
      ),
      stub_model(InvestmentAccountCompany,
        :investment_account_id => 1,
        :name => "Name"
      )
    ])
  end

  it "renders a list of investment_account_companies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
