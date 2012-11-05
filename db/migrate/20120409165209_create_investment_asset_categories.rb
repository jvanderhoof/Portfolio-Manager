class CreateInvestmentAssetCategories < ActiveRecord::Migration
  def change
    create_table :investment_asset_categories do |t|
      t.string :name
      t.string :key

      t.timestamps
    end
    add_index :investment_asset_categories, :key
  end
end