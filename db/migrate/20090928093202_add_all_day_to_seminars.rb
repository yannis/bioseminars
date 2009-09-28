class AddAllDayToSeminars < ActiveRecord::Migration
  def self.up
    add_column :seminars, :all_day, :boolean
  end

  def self.down
    remove_column :seminars, :all_day
  end
end
