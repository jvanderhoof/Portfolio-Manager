class PortfolioDescriptionToText < ActiveRecord::Migration
  def up
    change_column :portfolios, :description, :text
  end

  def down
    change_column :portfolios, :description, :string
  end
end