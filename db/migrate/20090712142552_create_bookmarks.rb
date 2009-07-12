class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks do |t|
      t.string :username
      t.string :title
      t.string :url
      t.integer :count
      t.boolean :status
      t.string :comment
      t.boolean :is_private
      t.datetime :timestamp
      t.string :key
    end
  end

  def self.down
    drop_table :bookmarks
  end
end