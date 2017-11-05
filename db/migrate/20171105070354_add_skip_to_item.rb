class AddSkipToItem < ActiveRecord::Migration[5.1]
  def change
    change_table :items do | t |
      t.boolean :skip, default: false
    end
  end
end
