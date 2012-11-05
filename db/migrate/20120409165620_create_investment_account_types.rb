class CreateInvestmentAccountTypes < ActiveRecord::Migration
  def change
    create_table :investment_account_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :investment_account_types, :name
  end
end