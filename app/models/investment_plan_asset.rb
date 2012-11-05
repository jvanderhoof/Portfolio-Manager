class InvestmentPlanAsset < ActiveRecord::Base
  belongs_to :investment_asset
  belongs_to :investment_plan
end
