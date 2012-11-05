class AddPortfolioTemplate < ActiveRecord::Migration
  def up
    add_column :portfolios, :template, :boolean, :default => 0
  end

  def down
    remove_column :portfolios, :template
  end
end