class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.integer :model_id, :null => false
      t.string :model_type, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
