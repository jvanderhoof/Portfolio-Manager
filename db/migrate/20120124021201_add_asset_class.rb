class AddAssetClass < ActiveRecord::Migration
  def up
    add_column :assets, :asset_category, :string
  end

  def down
    remove_column :assets, :asset_category
  end
end