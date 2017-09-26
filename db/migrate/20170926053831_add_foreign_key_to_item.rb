class AddForeignKeyToItem < ActiveRecord::Migration[5.1]
  def change
    change_table :items do | t |
      t.integer :feed_id
    end
  end
end
