class AddUrlToItems < ActiveRecord::Migration[5.1]
  def change
    change_table :items do | t |
      t.text :url
    end
  end
end
