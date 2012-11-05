require 'spec_helper'
require 'allocator'

describe Allocator do
  it "should provide the correct percent and amounts" do
    rtn = Allocator.set_account_asset_amount_percent(12000, 5500, 5000, 5000)
    rtn[:amount].as_currency.should == 2291.67  #{:amount => 2291.67, :percent => 45.83}
    rtn[:percent].as_currency.should == 45.83
    rtn = Allocator.set_account_asset_amount_percent(15416.30, 4400, 2708.15, 5000)
    rtn[:amount].as_currency.should == 772.94 #  {:amount => 772.94, :percent => 15.46}
    rtn[:percent].as_currency.should == 15.46
  end
  
  it "should correctly order the the assets based on to plan and accounts" do
    plan = {1 => 10, 2 => 20, 3 => 30, 4 => 25, 5 => 15}
    accounts_assets = [[1,2,3,5],[1,2,3,4,5],[1,2,3,4,5],[3,4,5]]
    Allocator.weighted_order(plan, accounts_assets).should == [4,2,1,3,5]
  end
  
#=begin  
  it "should provide an analyzed portfolio" do
    plan = {1 => 10, 2 => 20, 3 => 30, 4 => 25, 5 => 15}
    accounts = [{
      :assets => {
        1 => {:available => 1},
        2 => {:available => 2},
        3 => {:available => 3},
        4 => {:alternative => 6},
        5 => {:available => 5}}, :total_value => 10000
      },{
      :assets => {
        1 => {:available => 1},
        2 => {:available => 2},
        3 => {:available => 3},
        4 => {:available => 4},
        5 => {:available => 5}}, :total_value => 5000
      },{
      :assets => {
        1 => {:available => 1},
        2 => {:available => 2},
        3 => {:available => 3},
        4 => {:available => 4},
        5 => {:available => 5}}, :total_value => 5000          
      }, {
      :assets => {
        1 => {:alternative => 8},
        2 => {:alternative => 9},
        3 => {:available => 3},
        4 => {:available => 4},
        5 => {:available => 5}}, :total_value => 2000
      }
    ]    
    percentages = Allocator.build_portfolios(plan, accounts, 22000)
    percentages.each do |account|
      value = 0
      negatives = false
      account.each_value do |v| 
        negatives = true if v < 0
        value += v
      end
      value.should_not == true
      value.round.should == 100
    end
  end
#=end
#=begin
  it "should provide a correct analyzed portfolio for a poor selection" do
    plan = {1 => 10, 2 => 70, 3 => 5, 4 => 8, 5 => 7}
    accounts = [{:assets => [1,2,3,5], :total_value => 1000},{:assets => [1,3,4,5], :total_value => 5000},{:assets => [1,3,4,5], :total_value => 5000},{:assets => [3,4,5], :total_value => 2000}]
    accounts = [{
      :assets => {
        1 => {:available => 1},
        2 => {:available => 2},
        3 => {:available => 3},
        4 => {:alternative => 6},
        5 => {:available => 5}}, :total_value => 1000
      },{
      :assets => {
        1 => {:available => 1},
        2 => {:alternative => 7},
        3 => {:available => 3},
        4 => {:available => 4},
        5 => {:available => 5}}, :total_value => 5000
      },{
      :assets => {
        1 => {:available => 1},
        2 => {:alternative => 7},
        3 => {:available => 3},
        4 => {:available => 4},
        5 => {:available => 5}}, :total_value => 5000          
      }, {
      :assets => {
        1 => {:alternative => 8},
        2 => {:alternative => 9},
        3 => {:available => 3},
        4 => {:available => 4},
        5 => {:available => 5}}, :total_value => 2000
      }
    ]    
    percentages = Allocator.build_portfolios(plan, accounts, 13000)
    percentages.each do |account|
      value = 0
      negatives = false
      account.each_value do |v| 
        negatives = true if v < 0
        value += v
      end
      value.should_not == true
      value.round.should == 100
    end
  end
#=end
end