class CreateTableSeminarsSpeakers < ActiveRecord::Migration
  def self.up
    create_table :seminars_speakers, :id => false, :force => true do |t|
      t.integer :person_id, :null => false
      t.integer :seminar_id, :null => false
    end
  end

  def self.down
    drop_table :seminars_speakers
  end
end
