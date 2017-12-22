class AddisFinishedToFeeds < ActiveRecord::Migration[5.1]
  def change
    change_table :feeds do | t |
      t.integer :total_ep_count
      t.boolean :is_finished
      t.boolean :auto_finish
    end
  end
end
