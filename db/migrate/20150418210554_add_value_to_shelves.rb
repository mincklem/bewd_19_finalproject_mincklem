class AddValueToShelves < ActiveRecord::Migration
  def change
    add_column :shelves, :value, :integer
  end
end
