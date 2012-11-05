class InvestmentPlan < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :user
  
  has_many :buy_lists
  has_many :active_buy_lists, :class_name => 'BuyList', :conditions => {:purchased => false}
  has_many :investment_plan_assets
    
  validates_presence_of :name, :portfolio_id, :contribution_amount, :time_period, :start_date
  
  after_save :check_portfolio_assets
  
  def check_portfolio_assets
    portfolio_asset_hash = self.portfolio.portfolio_assets.inject({}){|result, i| result[i.investment_asset_id] = i; result}
    investment_plan_asset_hash = self.investment_plan_assets.inject({}){|result, i| result[i.investment_asset_id] = i; result}
    investment_asset_ids = portfolio_asset_hash.keys | investment_plan_asset_hash.keys
    investment_asset_ids.each do |ia_id|
      if portfolio_asset_hash.has_key?(ia_id) && !investment_plan_asset_hash.has_key?(ia_id)
        self.investment_plan_assets << InvestmentPlanAsset.new({:investment_asset_id => ia_id, :shares => 0})
      end
    end
  end
  
  def next_buy_date
    return self.start_date if self.start_date > Date.today
    if buy_lists.length == 0
      next_date(self.start_date)
    else
      date = next_date(self.start_date)
      while date < Date.today do
        date = next_date(date)
      end
      date
    end
  end
  
  def next_date(date)
    case self.time_period
    when 'Weekly'
      date + 1.week
    when 'Bi-Weekly'
      date + 2.week
    when 'Monthly'
      date + 1.month
    when 'Twice Monthly'
      if date.day > 15
        date - 15.days + 1.month
      else
        15.days.since(date)
      end
    end
  end
  
  
    
end
