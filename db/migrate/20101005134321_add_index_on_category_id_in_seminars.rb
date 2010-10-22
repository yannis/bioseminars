class AddIndexOnCategoryIdInSeminars < ActiveRecord::Migration
  def self.up
    add_index :seminars, :category_id, :unique => false
    add_index :seminars, :location_id, :unique => false
    add_index :seminars, :user_id, :unique => false
  end

  def self.down
    remove_index :seminars, :user_id
    remove_index :seminars, :location_id
    remove_index :seminars, :category_id
  end
end
