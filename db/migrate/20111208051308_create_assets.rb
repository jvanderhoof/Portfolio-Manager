class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.string :symbol

      t.timestamps
    end
    add_index :assets, :symbol
  end
end