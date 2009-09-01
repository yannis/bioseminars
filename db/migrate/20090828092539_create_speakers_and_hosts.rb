class CreateSpeakersAndHosts < ActiveRecord::Migration
  def self.up
    create_table :speakers do |t|
      t.string :name
      t.string :affiliation
      t.string :email

      t.timestamps
    end
    
    create_table :hosts do |t|
      t.string :name
      t.string :affiliation
      t.string :email

      t.timestamps
    end
    
    drop_table :seminars_speakers    
    create_table :seminars_speakers, :id => false, :force => true do |t|
      t.integer :seminar_id, :null => false
      t.integer :speaker_id, :null => false
    end
    
    drop_table :hosts_seminars    
    create_table :hosts_seminars, :id => false, :force => true do |t|
      t.integer :host_id, :null => false
      t.integer :seminar_id, :null => false
    end
    
    drop_table :people
    
  end

  def self.down
    create_table :people do |t|
      t.string :name
      t.string :affiliation
      t.string :email

      t.timestamps
    end
    drop_table :speakers
    drop_table :hosts
      
    drop_table :seminars_speakers    
    create_table :seminars_speakers, :id => false, :force => true do |t|
      t.integer :seminar_id, :null => false
      t.integer :person_id, :null => false
    end
    
    drop_table :hosts_seminars    
    create_table :hosts_seminars, :id => false, :force => true do |t|
      t.integer :person_id, :null => false
      t.integer :seminar_id, :null => false
    end 
  end
end
