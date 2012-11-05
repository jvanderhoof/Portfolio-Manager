class CreateAccountCompanyAssets < ActiveRecord::Migration
  def change
    create_table :account_company_assets do |t|
      t.integer :investment_account_company_id
      t.integer :investment_asset_id

      t.timestamps
    end
    add_index :account_company_assets, [:investment_account_company_id, :investment_asset_id], :name => "account_company_assets_idx"
  end
end