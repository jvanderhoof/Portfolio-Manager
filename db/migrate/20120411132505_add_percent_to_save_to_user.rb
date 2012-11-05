class AddPercentToSaveToUser < ActiveRecord::Migration
  def change
    add_column :users, :percent_to_save, :float, :default => 10
    add_column :users, :send_emails, :boolean, :default => false, :null => false
  end
end