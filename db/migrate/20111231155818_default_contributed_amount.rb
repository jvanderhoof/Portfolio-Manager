class DefaultContributedAmount < ActiveRecord::Migration
  def up
    change_column_default :investment_plans, :contribution_amount, 0
  end

  def down
  end
end