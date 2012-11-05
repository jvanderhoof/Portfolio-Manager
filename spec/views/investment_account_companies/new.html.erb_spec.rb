require 'spec_helper'

describe "investment_account_companies/new.html.erb" do
  before(:each) do
    assign(:investment_account_company, stub_model(InvestmentAccountCompany,
      :investment_account_id => 1,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new investment_account_company form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => investment_account_companies_path, :method => "post" do
      assert_select "input#investment_account_company_investment_account_id", :name => "investment_account_company[investment_account_id]"
      assert_select "input#investment_account_company_name", :name => "investment_account_company[name]"
    end
  end
end
