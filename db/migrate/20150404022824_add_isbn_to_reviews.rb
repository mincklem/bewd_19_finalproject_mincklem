class AddIsbnToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :isbn, :integer
  end
end
