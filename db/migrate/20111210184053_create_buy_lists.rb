class CreateBuyLists < ActiveRecord::Migration
  def change
    create_table :buy_lists do |t|
      t.integer :investment_plan_id
      t.date :date
      t.float :total_amount, :default => 0
      t.boolean :purchased, :default => false

      t.timestamps
    end
    add_index :buy_lists, :investment_plan_id
  end
end