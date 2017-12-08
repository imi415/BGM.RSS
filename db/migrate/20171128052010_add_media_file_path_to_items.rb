class AddMediaFilePathToItems < ActiveRecord::Migration[5.1]
  def change
    change_table :items do | t |
      t.string :media_path
    end
  end
end
