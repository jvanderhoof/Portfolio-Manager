class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :name
      t.float :available_funds, :default => 0
      t.float :current_value, :default => 0
      t.float :contributed_value, :default => 0

      t.timestamps
    end
  end
end
