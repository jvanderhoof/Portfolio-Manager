class AddReturnCache < ActiveRecord::Migration
  def up
    add_column :assets, :one_year_return, :float
    add_column :assets, :three_year_return, :float
    add_column :assets, :five_year_return, :float
    add_column :assets, :ten_year_return, :float
    add_column :assets, :twenty_year_return, :float
    add_column :portfolios, :one_year_return, :float
    add_column :portfolios, :three_year_return, :float
    add_column :portfolios, :five_year_return, :float
    add_column :portfolios, :ten_year_return, :float
    add_column :portfolios, :twenty_year_return, :float
  end

  def down
    remove_column :assets, :one_year_return
    remove_column :assets, :three_year_return
    remove_column :assets, :five_year_return
    remove_column :assets, :ten_year_return
    remove_column :assets, :twenty_year_return
    remove_column :portfolios, :one_year_return
    remove_column :portfolios, :three_year_return
    remove_column :portfolios, :five_year_return
    remove_column :portfolios, :ten_year_return
    remove_column :portfolios, :twenty_year_return
  end
end