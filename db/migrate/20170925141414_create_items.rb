class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :status
      t.timestamps
    end
    add_foreign_key :items, :feeds
  end
end
