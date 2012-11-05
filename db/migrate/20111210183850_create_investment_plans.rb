class CreateInvestmentPlans < ActiveRecord::Migration
  def change
    create_table :investment_plans do |t|
      t.float :initial_contribution, :default => 0
      t.string :time_period
      t.date :start_date
      t.float :banked_value, :default => 0
      t.float :total_contributed_value, :default => 0
      t.float :contribution_amount
      t.integer :portfolio_id

      t.timestamps
    end
  end
end
