class AddHas401k < ActiveRecord::Migration
  def up
    add_column :people, :has_401k, :boolean, :default => true
  end

  def down
    remove_column :people, :has_401k
  end
end