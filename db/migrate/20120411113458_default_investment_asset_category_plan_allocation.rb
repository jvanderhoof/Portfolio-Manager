class DefaultInvestmentAssetCategoryPlanAllocation < ActiveRecord::Migration
  def up
    change_column_default :investment_asset_category_plans, :allocation_percentage, 0
  end

  def down
    change_column_default :investment_asset_category_plans, :allocation_percentage, nil
  end
end