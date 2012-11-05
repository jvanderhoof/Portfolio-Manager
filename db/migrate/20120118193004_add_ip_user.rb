class AddIpUser < ActiveRecord::Migration
  def up
    add_column :investment_plans, :user_id, :integer
    add_index :investment_plans, :user_id
  end

  def down
    remove_column :investment_plans, :user_id
  end
end