class AddOffsetToFeed < ActiveRecord::Migration[5.1]
  def change
    change_table :feeds do | t |
      t.integer :offset
    end
  end
end
