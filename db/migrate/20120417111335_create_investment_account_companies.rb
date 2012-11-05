class CreateInvestmentAccountCompanies < ActiveRecord::Migration
  def change
    create_table :investment_account_companies do |t|
      t.string :name
      t.text :available_assets

      t.timestamps
    end

    add_column :investment_accounts, :investment_account_company_id, :integer
  end
end