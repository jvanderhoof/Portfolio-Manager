class AddAssetClassification < ActiveRecord::Migration
  def up
    add_column :assets, :morningstar_classification, :string
    add_column :assets, :expense_ratio, :float
  end

  def down
    remove_column :assets, :expense_ratio
    remove_column :assets, :morningstar_classification    
  end
end