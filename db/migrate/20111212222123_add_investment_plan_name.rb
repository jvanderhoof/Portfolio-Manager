class AddInvestmentPlanName < ActiveRecord::Migration
  def up
    add_column :investment_plans, :name, :string
  end

  def down
    remove_column :investment_plans, :name
  end
end