class AddUserToPortfolio < ActiveRecord::Migration
  def change
    add_column :portfolios, :user_id, :integer
    add_index :portfolios, :user_id
  end
end