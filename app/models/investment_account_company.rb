class InvestmentAccountCompany < ActiveRecord::Base
  attr_accessor :is_saved
  
  has_many :account_company_assets
  has_many :investment_assets, :through => :account_company_assets
  
  after_save :set_available_funds
  
  def set_available_funds
    if self.is_saved.blank? || !self.is_saved == true
      self.available_assets.split(/\s|,/).each do |symbol|
        next if symbol.strip.blank?
        investment_asset = InvestmentAsset.find_or_create_by_symbol({:symbol => symbol.strip.upcase})
        investment_assets << investment_asset unless investment_assets.include?(investment_asset)
      end
      self.is_saved = true
    end
  end
  
end
