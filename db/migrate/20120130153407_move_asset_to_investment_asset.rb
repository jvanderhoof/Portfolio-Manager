class MoveAssetToInvestmentAsset < ActiveRecord::Migration
  def up
    rename_column :asset_histories, :asset_id, :investment_asset_id
    rename_column :asset_values, :asset_id, :investment_asset_id
    rename_column :buy_list_assets, :asset_id, :investment_asset_id
    rename_column :investment_plan_assets, :asset_id, :investment_asset_id
    rename_column :portfolio_assets, :asset_id, :investment_asset_id
    
  end

  def down
    rename_column :asset_histories, :investment_asset_id, :asset_id
    rename_column :asset_values, :investment_asset_id, :asset_id
    rename_column :buy_list_assets, :investment_asset_id, :asset_id
    rename_column :investment_plan_assets, :investment_asset_id, :asset_id
    rename_column :portfolio_assets, :investment_asset_id, :asset_id
  end
end