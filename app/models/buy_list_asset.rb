class BuyListAsset < ActiveRecord::Base
  belongs_to :buy_list
  belongs_to :investment_asset
end
