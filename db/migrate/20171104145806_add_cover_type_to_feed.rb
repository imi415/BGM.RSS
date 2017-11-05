class AddCoverTypeToFeed < ActiveRecord::Migration[5.1]
  def change
    change_table :feeds do | t |
      t.string :cover_type
    end
  end
end
