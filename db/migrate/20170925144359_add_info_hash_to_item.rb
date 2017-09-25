class AddInfoHashToItem < ActiveRecord::Migration[5.1]
  def change
    change_table :items do | t |
      t.string :info_hash
    end
  end
end
