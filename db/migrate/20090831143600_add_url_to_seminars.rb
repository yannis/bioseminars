class AddUrlToSeminars < ActiveRecord::Migration
  def self.up
    add_column :seminars, :url, :string
  end

  def self.down
    remove_column :seminars, :url
  end
end
