class AddTypeToInvestmentAsset < ActiveRecord::Migration
  def change
    remove_column :investment_assets, :morningstar_classification
    add_column :investment_assets, :investment_asset_category_id, :integer
    add_column :investment_assets, :investment_asset_type_id, :integer

    add_index :investment_assets, :investment_asset_category_id, :name => "investment_asset_cat_idx"
    add_index :investment_assets, :investment_asset_type_id
    add_index :investment_assets, [:investment_asset_category_id, :investment_asset_type_id], :name => "investment_assets_category_type_idx"
  end
  
end