class CreateIndexInvestmentAssets < ActiveRecord::Migration
  def change
    create_table :index_investment_assets do |t|
      t.integer :investment_asset_id
      t.integer :index_id
      t.date :date_added
      t.date :date_removed

      t.timestamps
    end
  end
end
