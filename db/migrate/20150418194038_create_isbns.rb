class CreateIsbns < ActiveRecord::Migration
  def change
    create_table :isbns do |t|

      t.timestamps null: false
    end
  end
end
