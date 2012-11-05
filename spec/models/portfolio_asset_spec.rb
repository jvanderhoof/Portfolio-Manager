require 'spec_helper'

describe PortfolioAsset do
  before(:each) do
    @portfolio_asset = PortfolioAsset.create({:asset => Asset.create({:current_value => 40})})
    @buy_list_assets = [
        BuyListAsset.create({:share_count => 5, :share_price => 10, :created_at => 180.days.ago}), 
        BuyListAsset.create({:share_count => 5, :share_price => 15, :created_at => 150.days.ago}), 
        BuyListAsset.create({:share_count => 5, :share_price => 20, :created_at => 120.days.ago}),
        BuyListAsset.create({:share_count => 5, :share_price => 25, :created_at => 90.days.ago}),
        BuyListAsset.create({:share_count => 5, :share_price => 30, :created_at => 60.days.ago}),
        BuyListAsset.create({:share_count => 5, :share_price => 35, :created_at => 30.days.ago})        
      ]
  end
  
  it "should calculate annual return" do
    @portfolio_asset.calculate_return(@buy_list_assets).should == 77.7778
  end
  
  it "should return 0 for no change in fund" do
    buy_list_assets = [
        BuyListAsset.create({:share_count => 5, :share_price => 40, :created_at => 180.days.ago}), 
    ]
    @portfolio_asset.calculate_return(buy_list_assets).should == 0
  end
end
