class AddDividend < ActiveRecord::Migration
  def up
    add_column :asset_histories, :dividend, :float
    add_index :asset_histories, [:asset_id, :dividend], :name => "asset_dividend_idx"
  end

  def down
    remove_column :asset_histories, :dividend
    remove_index :asset_dividend_idx
  end
end