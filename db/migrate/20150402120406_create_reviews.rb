class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :isbn
      t.string :title
      t.string :review_text
      t.integer :star_rating
      t.string :shelves
      t.integer :likes

      t.timestamps null: false
    end
  end
end
