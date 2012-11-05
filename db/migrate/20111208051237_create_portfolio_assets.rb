class CreatePortfolioAssets < ActiveRecord::Migration
  def change
    create_table :portfolio_assets do |t|
      t.float :percentage
      t.integer :asset_id
      t.integer :portfolio_id
      t.integer :shares, :default => 0
      t.float :current_value, :default => 0

      t.timestamps
    end
    add_index :portfolio_assets, :asset_id
    add_index :portfolio_assets, :portfolio_id
  end
end