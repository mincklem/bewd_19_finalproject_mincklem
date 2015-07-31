class AddPlatformColumnToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :platform, :string
  end
end
