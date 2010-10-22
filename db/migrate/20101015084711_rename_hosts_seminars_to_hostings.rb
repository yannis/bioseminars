class RenameHostsSeminarsToHostings < ActiveRecord::Migration
  def self.up
    rename_table :hosts_seminars, :hostings
    add_column :hostings, :id, :primary_key
    add_index :hostings, :seminar_id
    add_index :hostings, :host_id
  end
  
  

  def self.down
    remove_column :hostings, :id 
    remove_index :hostings, :seminar_id
    remove_index :hostings, :host_id
    rename_table :hostings, :hosts_seminars
  end
end
