class AccountCompanyAsset < ActiveRecord::Base
  belongs_to :investment_account_company
  belongs_to :investment_asset
end
