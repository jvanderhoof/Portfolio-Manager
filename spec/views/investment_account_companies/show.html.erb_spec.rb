require 'spec_helper'

describe "investment_account_companies/show.html.erb" do
  before(:each) do
    @investment_account_company = assign(:investment_account_company, stub_model(InvestmentAccountCompany,
      :investment_account_id => 1,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
