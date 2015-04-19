class AddValueToShelves < ActiveRecord::Migration
  def change
    add_column :shelves, :value, :integer, :limit => 8
  end
end
