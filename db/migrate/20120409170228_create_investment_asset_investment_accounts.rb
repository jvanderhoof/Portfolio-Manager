class CreateInvestmentAssetInvestmentAccounts < ActiveRecord::Migration
  def change
    create_table :investment_asset_investment_accounts do |t|
      t.integer :investment_asset_id
      t.integer :investment_account_id

      t.timestamps
    end

    add_index :investment_asset_investment_accounts, :investment_asset_id, :name => 'iaia_investment_asset_idx'
    add_index :investment_asset_investment_accounts, :investment_account_id, :name => 'iaia_investment_account_idx'
  end
end