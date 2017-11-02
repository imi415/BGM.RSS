class AddTaskIdToItem < ActiveRecord::Migration[5.1]
  def change
    change_table :items do | t |
      t.integer :taskid
    end
  end
end
