class AddInternalToSeminars < ActiveRecord::Migration
  def self.up
    add_column :seminars, :internal, :boolean
    
    Seminar.find(:all).each{|s| s.update_attributes(:internal => false)}
    
  end

  def self.down
    remove_column :seminars, :internal
  end
end
