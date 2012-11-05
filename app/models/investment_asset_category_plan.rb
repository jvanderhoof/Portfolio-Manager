class InvestmentAssetCategoryPlan < ActiveRecord::Base
  belongs_to :plan
  belongs_to :investment_asset_category
end
