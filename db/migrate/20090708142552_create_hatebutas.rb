class CreateHatebutas < ActiveRecord::Migration
  def self.up
    create_table :hatebutas do |t|
      t.string :hatebuta_key
      t.string :timeline_key
      t.integer :timeline_id
      t.string :title
      t.string :description
      t.boolean :open_level

      t.timestamps
    end
  end

  def self.down
    drop_table :hatebutas
  end
end
