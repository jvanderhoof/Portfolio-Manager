class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.date :birthday
      t.float :income
      t.integer :user_id

      t.timestamps
    end
  end
end
