class AddPortfolioDescription < ActiveRecord::Migration
  def up
    add_column :portfolios, :description, :string
    add_column :portfolios, :order_by, :integer, :default => 0
    add_index :portfolios, :order_by
  end

  def down
    remove_column :portfolios, :description
    remove_column :portfolios, :order_by
  end
end