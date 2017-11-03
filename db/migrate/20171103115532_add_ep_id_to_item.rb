class AddEpIdToItem < ActiveRecord::Migration[5.1]
  def change
    change_table :items do | t |
      t.integer :ep_id
    end
  end
end
