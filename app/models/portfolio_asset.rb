class PortfolioAsset < ActiveRecord::Base
  has_many :buy_requests
  belongs_to :investment_asset
  belongs_to :portfolio
  
  def asset_symbol
    (self.investment_asset.present?) ? self.investment_asset.symbol : nil
  end
  
  def asset_symbol=(symbol)
    self.investment_asset = InvestmentAsset.find_or_create_by_symbol(symbol.upcase) unless symbol.blank?
  end
    
  def calculate_return(buy_list_assets)
    transactions = []
    buy_list_assets.each do |bla|      
      transactions << {:value => -(bla.share_count * bla.share_price).as_currency, :date => bla.created_at}
    end
    
    current_value = buy_list_assets.inject(0){|sum, i| sum += i.share_count * self.investment_asset.current_value.to_f}
    transactions << {:value => current_value, :date => Time.now}
    rtn = Calculator.xirr(transactions, -0.05)
    rtn
  end
end
