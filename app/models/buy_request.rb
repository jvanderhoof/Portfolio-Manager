class BuyRequest < ActiveRecord::Base
  belongs_to :investment_asset
  belongs_to :portfolio_assets
end
