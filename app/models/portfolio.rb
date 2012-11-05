require 'yahoo_stock'
require 'calculator'

class Portfolio < ActiveRecord::Base
  
  has_one :investment_plan

  has_many :portfolio_assets, :include => [:investment_asset], :order => 'percentage desc', :dependent => :destroy  
  accepts_nested_attributes_for :portfolio_assets, :allow_destroy => true, :reject_if => :all_blank
  
  belongs_to :user
    
  def current_asset_allocation
    rtn = {}
    total = 0
    return rtn if self.investment_plan.blank?
    self.investment_plan.investment_plan_assets.each do |ipa|
      sub_total = ipa.shares * ipa.investment_asset.current_value
      rtn[ipa.investment_asset_id] = sub_total
      total += sub_total
    end
    rtn.keys.each{|key| rtn[key] = rtn[key]/total }
    rtn
  end
    
  def clone(user_id)
    clone_portfolio = Portfolio.new(self.attributes.merge({:template => false, :user_id => user_id}))
    self.portfolio_assets.each do |pa|
      clone_portfolio.portfolio_assets << PortfolioAsset.create({:percentage => pa.percentage, :investment_asset_id => pa.investment_asset_id})
    end
    clone_portfolio.save
    clone_portfolio
  end  
  
  def buy_list_assets(investment_asset_id)
    rtn = []
    return rtn if self.investment_plan.blank?
    self.investment_plan.buy_lists.each do |bl|
      bl.buy_list_assets.each do |bla|
        rtn << bla if bla.investment_asset_id == investment_asset_id
      end
    end
    rtn
  end
  
  def total_return
    return 0 unless self.investment_plan.present? && self.investment_plan.buy_lists.present?
    transactions = []
    shares = {}
    self.investment_plan.buy_lists.each do |bl|
      bl.buy_list_assets.each do |bla|
        shares[bla.investment_asset_id] ||= 0
        transactions << {:value => -(bla.share_count * bla.share_price).as_currency, :date => bla.created_at}
        shares[bla.investment_asset_id] += bla.share_count
      end
    end
    current_value = 0
    shares.keys.each do |investment_asset_id|
      current_value += InvestmentAsset.find(investment_asset_id).current_value * shares[investment_asset_id]
    end
    transactions << {:value => current_value, :date => transactions.first[:date]} #Time.now
    Calculator.xirr(transactions, 0.05)
  end
  
  def portfolio_hash
    rtn = {}
    self.investment_plan.investment_plan_assets.each do |ipa|
      rtn[ipa.investment_asset_id] = {:asset_value => ipa.investment_asset.current_value, 
                                        :shares => ipa.shares, 
                                        :desired_percentage => self.portfolio_assets.select{|i| i.investment_asset_id == ipa.investment_asset_id }.first.percentage,
                                        :investment_asset => ipa.investment_asset                                        
                                      }
    end
    rtn
  end
  
  def historical(years=20, period='monthly', period_amount=500, trading_fee=0, create_csv=false)
    return {:compound_annual_growth => 0, :years => 0, :values => []} if self.portfolio_assets.blank?
    
    value_data = []
    csv_data = [['date', 'price']] if create_csv
    transactions = []
    days = years * 365
    self.portfolio_assets.each do |pa| 
      ah = AssetHistory.where(["investment_asset_id = ?", pa.investment_asset_id]).order('day asc').first
      puts "asset: #{pa.investment_asset_id} => #{ah.inspect}" if ah.blank?
      days_ago = Date.today - ah.day
      days = days_ago if days_ago < days
    end
    years = (years < days/365.0) ? years : days/365.0
    banked_value = 0
    total_invested_value = 0
    portfolio_assets = {}
    self.portfolio_assets.each{|pa| portfolio_assets[pa.investment_asset_id] = {:asset_value => 0, :shares => 0, :desired_percentage => pa.percentage, :asset => pa.investment_asset}}
    case period
    when 'monthly'
      months = (years * 12).to_i
      (0..months).each do |months_ago|
        next if months_ago == months
        amount_to_spend = banked_value + period_amount.to_f
        self.portfolio_assets.each do |pa|
          ah = AssetHistory.where(["investment_asset_id = ? and day >= ?", pa.investment_asset_id, (months - months_ago).months.ago]).order('day asc').first
          break if ah.blank?
          portfolio_assets[pa.investment_asset_id][:asset_value] = ((ah.open + ah.close)/2).as_currency
          dividends = AssetHistory.where(["investment_asset_id = ? and day >= ? and day < ? and dividend is not null", pa.investment_asset_id, 1.month.ago(ah.day), ah.day]).inject(0){|result,i| result + i.dividend}
          unless dividends == 0.0
            value = (portfolio_assets[pa.investment_asset_id][:shares] * dividends).round(4)
            amount_to_spend += value
          end
        end
        #puts "portfolio_assets: #{portfolio_assets.to_yaml}"
        buy_list = BuyList.generate_buy_list(portfolio_assets, amount_to_spend)
        sub_amount = 0
        buy_list.keys.each do |key|
          total_invested_value += portfolio_assets[key][:asset_value] * buy_list[key]
          amount_to_spend -= portfolio_assets[key][:asset_value] * buy_list[key]
          sub_amount += portfolio_assets[key][:asset_value] * buy_list[key]
        end
        #puts "total_invested_value: #{total_invested_value}"
        transactions << {:value => -(sub_amount).as_currency, :date => (months - months_ago).months.ago}
        csv_data << [(months - months_ago).months.ago.strftime('%m/%d/%Y'), -(sub_amount).as_currency] if create_csv #
        banked_value = amount_to_spend.as_currency
        
        # portfolio value
        portfolio_total = 0
        portfolio_assets.each_pair do |key, value|
          portfolio_total += (value[:asset_value] * value[:shares])
        end
        value_data << {:date => (months - months_ago).months.ago, :value => portfolio_total, :cost => total_invested_value} #.strftime('%m/%d/%Y')
        #puts "portfolio value: #{portfolio_total}"
      end
    end
    
    total_value = self.portfolio_assets.inject(0){|result, i| result + i.investment_asset.current_value * portfolio_assets[i.investment_asset_id][:shares]}
    transactions << {:value => total_value.as_currency, :date => 0.months.ago}
    csv_data << [0.months.ago.strftime('%m/%d/%Y'), total_value.as_currency] if create_csv
    
    if create_csv
      CSV.open("doc/#{self.name.gsub(' ','_').gsub('/','_')}.csv", "w") do |csv|
        csv_data.each do |row|
          csv << row
        end
      end
    end
    {:compound_annual_growth => (Calculator.xirr(transactions, 0.05) * 100).round(4), :years => (days.to_f/365).round(1), :data => value_data}
  end
end
