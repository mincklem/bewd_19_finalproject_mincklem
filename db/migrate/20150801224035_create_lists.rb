class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.text :list

      t.timestamps null: false
    end
  end
end
