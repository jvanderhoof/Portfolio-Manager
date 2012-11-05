class InvestmentAssetInvestmentAccount < ActiveRecord::Base
  belongs_to :investment_asset
  belongs_to :investment_account
end
