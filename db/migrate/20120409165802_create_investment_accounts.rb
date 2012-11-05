class CreateInvestmentAccounts < ActiveRecord::Migration
  def change
    create_table :investment_accounts do |t|
      t.integer :investment_account_type_id
      t.integer :person_id
      t.float :match, :default => 0
      t.string :contribution_frequency
      t.text :available_funds

      t.timestamps
    end
    add_index :investment_accounts, :investment_account_type_id
    add_index :investment_accounts, :person_id
  end
end