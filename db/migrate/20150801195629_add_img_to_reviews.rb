class AddImgToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :img, :string
  end
end
