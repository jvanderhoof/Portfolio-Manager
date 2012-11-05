require 'spec_helper'

describe BuyList do
  before(:each) do
    @portfolio_hash = {
      1 => {:asset_value => 10, :shares => 0, :desired_percentage => 50},
      2 => {:asset_value => 10, :shares => 0, :desired_percentage => 30},
      3 => {:asset_value => 10, :shares => 0, :desired_percentage => 15},
      4 => {:asset_value => 10, :shares => 0, :desired_percentage => 5}
    }    
  end
    
  it "should select the a correct initial buy list" do
    BuyList.generate_buy_list(@portfolio_hash, 1000.00).should == {1 => 50, 2 => 30, 3 => 15, 4 => 5}
  end
  
  it "should select the correct first buy" do
    portfolio_hash = {
      1 => {:asset_value => 10, :shares => 10, :desired_percentage => 50},
      2 => {:asset_value => 10, :shares => 1, :desired_percentage => 30},
      3 => {:asset_value => 10, :shares => 1, :desired_percentage => 15},
      4 => {:asset_value => 10, :shares => 1, :desired_percentage => 5}
    }
    BuyList.next_buy(portfolio_hash).should == 2
  end
  
  it "should not buy anything for very small contributions" do
    BuyList.generate_buy_list(@portfolio_hash, 5.00).should == {}
  end

  it "should select the correct second buy" do
    @portfolio_hash[1][:shares] = 1
    BuyList.next_buy(@portfolio_hash).should == 2
  end
    
  it "should set correct date for bi-monthly for beginning of month" do
    date = Date.new(2011, 10, 3)
    BuyList.next_date(date, 'Twice Monthly').should == Date.new(2011,10,18)
  end
  
  it "should set correct date for bi-monthly for end of month" do
    date = Date.new(2011, 10, 18)
    BuyList.next_date(date, 'Twice Monthly').should == Date.new(2011,11,3)    
  end
  
  it "should set correct date form weekly" do
    date = Date.new(2011, 10, 18)
    bl = BuyList.new
    BuyList.next_date(date, 'Weekly').should == Date.new(2011,10,25)    
  end

  it "should set correct date form bi-weekly" do
    date = Date.new(2011, 10, 3)
    BuyList.next_date(date, 'Bi-Weekly').should == Date.new(2011,10,17)    
  end

  it "should set correct date form montly" do
    date = Date.new(2011, 10, 3)
    BuyList.next_date(date, 'Monthly').should == Date.new(2011,11,3)    
  end

end
