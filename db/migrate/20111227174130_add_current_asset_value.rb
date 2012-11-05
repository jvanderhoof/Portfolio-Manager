class AddCurrentAssetValue < ActiveRecord::Migration
  def up
    add_column :assets, :current_value, :float
  end

  def down
    remove_column :assets, :current_value
  end
end