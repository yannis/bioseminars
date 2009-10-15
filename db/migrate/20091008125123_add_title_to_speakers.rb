class AddTitleToSpeakers < ActiveRecord::Migration
  def self.up
    add_column :speakers, :title, :string
  end

  def self.down
    remove_column :speakers, :title
  end
end
