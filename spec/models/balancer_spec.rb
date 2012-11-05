require 'spec_helper'
require 'balancer'

describe Balancer do
#=begin
  it "should provide the correct roth match for single under $100,000" do
    Balancer.roth_ira_contribution_amount([40], [100_000], 100_000, :single).should == [5_000]
  end

  it "should provide the correct roth match for single over $125,000" do
    Balancer.roth_ira_contribution_amount([40], [126_000], 126_000, :single).should == [0]
  end

  it "should provide the correct roth match for single between $110,000 and $125,000" do
    Balancer.roth_ira_contribution_amount([40], [117_500], 117_500, :single).should == [2_500]
  end

  it "should provide the correct roth match for single over 50 under $100,000" do
    Balancer.roth_ira_contribution_amount([55], [100_000], 100_000, :single).should == [6_000]
  end

  it "should provide the correct roth match for single over 50 over $125,000" do
    Balancer.roth_ira_contribution_amount([55], [126_000], 126_000, :single).should == [0]
  end

  it "should provide the correct roth match for single over 50 between $110,000 and $125,000" do
    Balancer.roth_ira_contribution_amount([55], [117_500], 117_500, :single).should == [3_000]
  end

  it "should provide the correct roth match for couple under $100,000" do
    Balancer.roth_ira_contribution_amount([40, 40], [50_000, 50_000], 100_00, :joint).should == [5_000,5_000]
  end
  
  it "should provide the correct roth match for couple over $183,000" do
    Balancer.roth_ira_contribution_amount([40, 40], [100_000, 84_000], 184_000, :joint).should == [0,0]
  end

  it "should provide the correct roth match for couple under 50 between $173,000 and $183,000" do
    Balancer.roth_ira_contribution_amount([40, 40], [100_000, 78_000], 187_00, :joint).should == [2_500,2_500]
  end

  it "should provide the correct roth match for couple under $100,000" do
    Balancer.roth_ira_contribution_amount([55, 55], [50_000, 50_000], 100_000, :joint).should == [6_000,6_000]
  end

  it "should provide the correct roth match for couple over 55 over $183,000" do
    Balancer.roth_ira_contribution_amount([55, 55], [100_000, 84_000], 184_000, :joint).should == [0,0]
  end

  it "should provide the correct roth match for couple over 50 between $173,000 and $183,000" do
    Balancer.roth_ira_contribution_amount([55, 55], [100_000, 78_000], 178_000, :joint).should == [3_000,3_000]
  end


  it "should provide the correct roth match for couple under $100,000" do
    Balancer.roth_ira_contribution_amount([55, 40], [50_000, 50_000], 100_000, :joint).should == [6_000,5_000]
  end

  it "should provide the correct roth match for couple over $183,000" do
    Balancer.roth_ira_contribution_amount([55, 40], [100_000, 84_000], 184_000, :joint).should == [0,0]
  end

  it "should provide the correct roth match for couple above and below 50 between $173,000 and $183,000" do
    Balancer.roth_ira_contribution_amount([55, 40], [100_000, 78_000], 178_000, :joint).should == [3_000,2_500]
  end
  
  # -------------------------------------------
  
  it "should calculate correct investment amounts for single under $100,000 with 2% savings rate" do
    Balancer.allocation([44], [{:income => 100_000, :match => 0.03, :has_401k => true}], :single, 0.02, 0.3).should == [{:a_401k => 2000, :roth_ira => 0, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for single under $100,000 with 2% savings rate and no 401k" do
    Balancer.allocation([44], [{:income => 100_000, :match => 0.03, :has_401k => false}], :single, 0.02, 0.3).should == [{:a_401k => 0, :roth_ira => 1400, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for single under $100,000 with 4% savings rate" do
    Balancer.allocation([44], [{:income => 100_000, :match => 0.03, :has_401k => true}], :single, 0.04, 0.3).should == [{:a_401k => 3000, :roth_ira => 700, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for single under $100,000 with 10% savings rate" do
    Balancer.allocation([44], [{:income => 100_000, :match => 0.03, :has_401k => true}], :single, 0.10, 0.3).should == [{:a_401k => 3000, :roth_ira => 4900, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for single under $100,000 with 20% savings rate" do
    Balancer.allocation([44], [{:income => 100_000, :match => 0.03, :has_401k => true}], :single, 0.20, 0.3).should == [{:a_401k => 12857.14, :roth_ira => 5000, :ira => 0, :investments => 0}]
  end
  
  
  it "should calculate correct investment amounts for single over $125,000 with 2% savings rate" do
    Balancer.allocation([44], [{:income => 130_000, :match => 0.03, :has_401k => true}], :single, 0.02, 0.3).should == [{:a_401k => 2600, :roth_ira => 0, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for single under $125,000 with 5% savings rate" do
    Balancer.allocation([44], [{:income => 130_000, :match => 0.03, :has_401k => true}], :single, 0.05, 0.3).should == [{:a_401k => 3900, :roth_ira => 0, :ira => 2600, :investments => 0}]
  end

  it "should calculate correct investment amounts for single under $125,000 with 20% savings rate" do
    Balancer.allocation([44], [{:income => 130_000, :match => 0.03, :has_401k => true}], :single, 0.20, 0.3).should == [{:a_401k => 17_000, :roth_ira => 0, :ira => 5000, :investments => 2800}]
  end
  
  
  it "should calculate correct investment amounts for couple under 50 under $150,000 with 2% savings rate" do
    ages = [44,44]
    incomes = [{:income => 70_000, :match => 0.03, :has_401k => true}, {:income => 80_000, :match => 0.05, :has_401k => true}]
    amounts = Balancer.allocation(ages, incomes, :single, 0.02, 0.3)
    amounts.should == [{:a_401k => 1400, :roth_ira => 0, :ira => 0, :investments => 0}, {:a_401k => 1600, :roth_ira => 0, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for couple under 50 under $150,000 with 5% savings rate" do
    ages = [44,44]
    incomes = [{:income => 70_000, :match => 0.03, :has_401k => true}, {:income => 80_000, :match => 0.05, :has_401k => true}]
    amounts = Balancer.allocation(ages, incomes, :joint, 0.05, 0.3)
    amounts.should == [{:a_401k => 2100, :roth_ira => 980, :ira => 0, :investments => 0}, {:a_401k => 4000, :roth_ira => 0, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for couple under 50 under $150,000 with 20% savings rate" do
    ages = [44,44]
    incomes = [{:income => 70_000, :match => 0.03, :has_401k => true}, {:income => 80_000, :match => 0.05, :has_401k => true}]
    amounts = Balancer.allocation(ages, incomes, :joint, 0.2, 0.3)
    amounts.should == [{:a_401k => 11_714.28, :roth_ira => 5000, :ira => 0, :investments => 0}, {:a_401k => 4000, :roth_ira => 5000, :ira => 0, :investments => 0}]
  end

  it "should calculate correct investment amounts for couple under 50 under $150,000 with 50% savings rate" do
    ages = [44,44]
    incomes = [{:income => 70_000, :match => 0.03, :has_401k => true}, {:income => 80_000, :match => 0.05, :has_401k => true}]
    amounts = Balancer.allocation(ages, incomes, :joint, 0.5, 0.3)
    amounts.should == [{:a_401k => 17_000, :roth_ira => 5000, :ira => 0, :investments => 18_700}, {:a_401k => 17_000, :roth_ira => 5000, :ira => 0, :investments => 0}]
  end
  
  it "should calculate correct investment amounts for couple under 50 over $183,000 with 50% savings rate" do
    ages = [44,44]
    incomes = [{:income => 100_000, :match => 0.03, :has_401k => true}, {:income => 84_000, :match => 0.05, :has_401k => true}]
    amounts = Balancer.allocation(ages, incomes, :joint, 0.5, 0.3)
    amounts.should == [{:a_401k => 17_000, :roth_ira => 0, :ira => 5000, :investments => 33_600}, {:a_401k => 17_000, :roth_ira => 0, :ira => 5000, :investments => 0}]
  end
end