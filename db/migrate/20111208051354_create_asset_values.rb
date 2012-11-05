class CreateAssetValues < ActiveRecord::Migration
  def change
    create_table :asset_values do |t|
      t.integer :asset_id
      t.float :value
      t.datetime :timestamp

      t.timestamps
    end
    add_index :asset_values, :asset_id
  end
end