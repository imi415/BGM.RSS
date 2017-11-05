class AddCoverToFeed < ActiveRecord::Migration[5.1]
  def change
    change_table :feeds do | t |
      t.binary :cover
    end
  end
end
