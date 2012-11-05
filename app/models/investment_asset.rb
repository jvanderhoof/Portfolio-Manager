class InvestmentAsset < ActiveRecord::Base
  has_many :portolio_assets
  has_many :buy_list_assets
  has_many :asset_histories, :order => 'day desc'
  has_many :investment_plan_assets

  has_many :investment_asset_investment_accounts
  has_many :investment_accounts, :through => :investment_asset_investment_accounts
  
  has_many :account_company_assets
  has_many :investment_account_companies, :through => :account_company_assets
  
  belongs_to :investment_asset_category

  before_create :verify_unique
  after_create :set_name_and_set_history
  
  before_save :set_category_hierarchy
  
  def set_category_hierarchy
    categories = []
    if self.investment_asset_category.present?
      more_categories = true
      category = self.investment_asset_category
      while more_categories
        categories << category.id
        if category.parent.present?
          category = category.parent
        else
          more_categories = false
        end
      end
    end
    self.category_hierarchy = "|#{categories.join('|')}|"
  end
  
  def verify_unique
    unless self.symbol.blank?
      self.symbol.upcase!
      if asset = InvestmentAsset.where(["symbol = ?", self.symbol]).first
        return asset
      end
    end
  end
  
  def set_name_and_set_history(set_name=true)    
    require 'yahoo_stock'
    require 'yahoo'

    if set_name && self.name.blank?
      quote = YahooStock::Quote.new(:stock_symbols => [self.symbol])
      quote.add_parameters(:name)
      results = quote.results(:to_hash).output
      self.update_attributes({:name => results.first[:name].strip.titleize, :current_value => results.first[:last_trade_price_only]})
    end
    
    if self.investment_asset_category_id.blank? || self.expense_ratio.blank?
      rtn = Yahoo.lookup(self.symbol)
      unless rtn[:category].blank?
        if self.investment_asset_category_id.blank?
          cat = InvestmentAssetCategory.find_or_create_by_key({:name => rtn[:category], :key => rtn[:category].downcase.strip})
          self.investment_asset_category_id = cat.id
        end
      end
      if self.expense_ratio.blank?
        self.expense_ratio = rtn[:expense_ratio]
      end
      self.save
    end

#=begin
    history = YahooStock::History.new(:stock_symbol => self.symbol, :start_date => Date.today - 30*365, :end_date => Date.today - 1)
    results = history.results(:to_hash).output
    results.each do |row|
      unless AssetHistory.exists?({:investment_asset_id => self.id, :day => Date.parse(row[:date])})
        AssetHistory.create({
            :investment_asset_id => self.id,
            :open => row[:open],
            :close => row[:close],
            :high => row[:high],
            :low => row[:low],
            :day => Date.parse(row[:date])
        })
        #puts "added: #{row[:date]}"
      end
    end
      
    history = YahooStock::History.new(:stock_symbol => self.symbol, :start_date => Date.today - 30*365, :end_date => Date.today - 1, :type => :dividend)
    results = history.results(:to_hash).output
    results.each do |row|
      ah = AssetHistory.where(['day = ? and investment_asset_id = ?', Date.parse(row[:date]), self.id]).first
      ah.update_attribute(:dividend, row[:dividends])
    end  
#=end
  end
  
  def set_name
    require 'open-uri'
    require 'json'
    unless self.symbol.blank?
      data = open("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=#{self.symbol}&callback=YAHOO.Finance.SymbolSuggest.ssCallback")
      line = data.each_line.first
      line = line.gsub!('YAHOO.Finance.SymbolSuggest.ssCallback(','')
      line = line.slice(0..line.length-2)
      result = JSON.parse(line)
      symbol = (result['ResultSet']['Result'].is_a?(Array)) ? result['ResultSet']['Result'].first : result['ResultSet']['Result']
      self.update_attribute(:name, symbol['name'])
    end
  end
end
