class CreateSeminars < ActiveRecord::Migration
  def self.up
    create_table :seminars do |t|
      t.string :title
      t.text :description
      t.datetime :start_on
      t.datetime :end_on
      t.integer :location_id
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :seminars
  end
end
