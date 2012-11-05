class BuyList < ActiveRecord::Base
  belongs_to :investment_plan
  has_many :buy_list_assets
  
  accepts_nested_attributes_for :buy_list_assets
  
  validates_presence_of :investment_plan_id
  
  before_create :update_plan_assets
  
  def self.next_buy(portfolio_hash)
    purchase_priority = []
    total_value = portfolio_hash.keys.inject(0){|sum, key| sum + portfolio_hash[key][:shares] * portfolio_hash[key][:asset_value]}.to_f
    portfolio_hash.keys.each do |key|
      current_value = portfolio_hash[key][:asset_value] * portfolio_hash[key][:shares]
      if current_value == 0
        weight = -(portfolio_hash[key][:desired_percentage].to_f/100)
      else
        weight = current_value / total_value - (portfolio_hash[key][:desired_percentage].to_f/100)
      end
      purchase_priority << {:investment_asset_id => key, :weight => weight}
    end
    purchase_priority.sort{|x,y| x[:weight] <=> y[:weight]}.first[:investment_asset_id]    
  end
  
  def self.generate_buy_list(portfolio_hash, amount, buy_hash={})
    next_purchase = next_buy(portfolio_hash)
    if portfolio_hash[next_purchase][:asset_value] <= amount
      buy_hash[next_purchase] ||= 0
      buy_hash[next_purchase] += 1
      portfolio_hash[next_purchase][:shares] += 1
      amount -= portfolio_hash[next_purchase][:asset_value]
      generate_buy_list(portfolio_hash, amount, buy_hash)
    end
    buy_hash
  end
  
  def self.buy_list_with_assets(investment_plan_id, portfolio_hash, amount)
    buy_list_hash = generate_buy_list(portfolio_hash, amount)
    buy_list = BuyList.new({:investment_plan_id => investment_plan_id})
    buy_list_hash.keys.each do |key|
      buy_list.buy_list_assets.build({:investment_asset => portfolio_hash[key][:investment_asset], :share_count => buy_list_hash[key], :share_price => portfolio_hash[key][:asset_value]})
    end
    buy_list
  end
    
  def update_plan_assets
    create_ids = self.investment_plan.portfolio.portfolio_assets.map{|pa| pa.investment_asset_id} - self.investment_plan.investment_plan_assets.map{|ipa| ipa.investment_asset_id}
    create_ids.each{|asset_id| self.investment_plan.investment_plan_assets << InvestmentPlanAsset.create({:investment_asset_id => asset_id})}
    self.investment_plan.save
    
    ipas = {}
    self.investment_plan.investment_plan_assets.each{|ipa| ipas[ipa.investment_asset_id] = ipa}
    self.buy_list_assets.each do |bla|
      ipas[bla.investment_asset_id].update_attribute(:shares, ipas[bla.investment_asset_id].shares + bla.share_count)
    end
  end
  
end
