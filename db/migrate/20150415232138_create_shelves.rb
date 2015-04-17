class CreateShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.integer :isbn
      t.text :shelves

      t.timestamps null: false
    end
  end
end
