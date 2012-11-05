class CreateBuyRequests < ActiveRecord::Migration
  def change
    create_table :buy_requests do |t|
      t.integer :portfolio_asset_id
      t.float :price
      t.integer :asset_id

      t.timestamps
    end
    add_index :buy_requests, :portfolio_asset_id
    add_index :buy_requests, :asset_id
  end
end