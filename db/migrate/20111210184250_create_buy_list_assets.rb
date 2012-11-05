class CreateBuyListAssets < ActiveRecord::Migration
  def change
    create_table :buy_list_assets do |t|
      t.integer :buy_list_id
      t.integer :asset_id
      t.integer :share_count, :default => 0
      t.float :share_price, :default => 0

      t.timestamps
    end
    add_index :buy_list_assets, :buy_list_id
    add_index :buy_list_assets, :asset_id
  end
end