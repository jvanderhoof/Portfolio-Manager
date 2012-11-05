class CreateInvestementAssetCategoryPlans < ActiveRecord::Migration
  def change
    create_table :investment_asset_category_plans do |t|
      t.integer :plan_id
      t.integer :investment_asset_category_id
      t.float :allocation_percentage

      t.timestamps
    end

    add_index :investment_asset_category_plans, :plan_id
    add_index :investment_asset_category_plans, :investment_asset_category_id, :name => 'inv_asset_category_plan_category_idx'
  end
end