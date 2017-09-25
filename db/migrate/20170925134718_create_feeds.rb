class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.boolean :is_enabled
      t.integer :amount
      t.datetime :last_updated
      t.timestamps
    end
  end
end
