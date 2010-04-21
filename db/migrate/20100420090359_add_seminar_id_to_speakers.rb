class AddSeminarIdToSpeakers < ActiveRecord::Migration
  def self.up
    add_column :speakers, :seminar_id, :integer
    for speaker in Speaker.all
      seminar_id = Seminar.find_by_sql("SELECT seminars.id, seminars_speakers.speaker_id FROM seminars INNER JOIN seminars_speakers ON seminars.id = seminars_speakers.seminar_id WHERE (seminars_speakers.speaker_id = #{speaker.id})").first.id.to_s
      speaker.update_attribute(:seminar_id, seminar_id)
    end
    drop_table :seminars_speakers
  end

  def self.down
    create_table :seminars_speakers, :id => false, :force => true do |t|
      t.integer :person_id, :null => false
      t.integer :seminar_id, :null => false
    end
    remove_column :speakers, :seminar_id
  end
end
