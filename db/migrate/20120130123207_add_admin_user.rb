class AddAdminUser < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :plan_level, :string, :default => 'basic'
    add_column :investment_plans, :email_updates, :boolean, :default => false
  end

  def down
    remove_column :users, :admin
    remove_column :users, :plan_level
    remove_column :investment_plans, :email_updates
  end
end