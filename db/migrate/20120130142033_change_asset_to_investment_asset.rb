class ChangeAssetToInvestmentAsset < ActiveRecord::Migration
  def change
    rename_table :assets, :investment_assets
  end
end
