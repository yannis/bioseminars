class CreateTableHostsSeminars < ActiveRecord::Migration
  def self.up
    create_table :hosts_seminars, :id => false, :force => true do |t|
      t.integer :person_id, :null => false
      t.integer :seminar_id, :null => false
    end
  end

  def self.down
    drop_table :hosts_seminars
  end
end
