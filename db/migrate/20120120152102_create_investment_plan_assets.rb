class CreateInvestmentPlanAssets < ActiveRecord::Migration
  def change
    create_table :investment_plan_assets do |t|
      t.integer :investment_plan_id
      t.integer :asset_id
      t.integer :shares

      t.timestamps
    end
    add_index :investment_plan_assets, :investment_plan_id
    add_index :investment_plan_assets, :asset_id
    add_index :investment_plan_assets, [:investment_plan_id, :asset_id], :name => "investment_plan_asset_idx", :unique => true
  end
end