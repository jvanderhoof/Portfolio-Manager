class CreateAssetHistories < ActiveRecord::Migration
  def change
    create_table :asset_histories do |t|
      t.integer :asset_id
      t.float :open
      t.float :close
      t.float :high
      t.float :low
      t.date :day

      t.timestamps
    end
    add_index :asset_histories, :asset_id
    add_index :asset_histories, [:asset_id, :day], :name => "asset_day_idx", :unique => true
  end
end
