class CreateIndices < ActiveRecord::Migration
  def change
    create_table :indices do |t|
      t.string :name

      t.timestamps
    end
  end
end
