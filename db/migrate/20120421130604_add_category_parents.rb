class AddCategoryParents < ActiveRecord::Migration
  def up
    add_column :investment_asset_categories, :parent_id, :integer
    add_column :investment_assets, :category_hierarchy, :string
    add_index :investment_assets, :category_hierarchy
  end

  def down
    remove_column :investment_asset_categories, :parent_id
    remove_column :investment_assets, :category_hierarchy
    remove_index :investment_assets, :category_hierarchy
  end
end