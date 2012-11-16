class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :documents, [:model_type, :model_id]
    add_index :locations, :building_id
    add_index :pictures, [:model_type, :model_id]
    add_index :speakers, :seminar_id
  end

  def self.down
    remove_index :documents, [:model_type, :model_id]
    remove_index :locations, :building_id
    remove_index :pictures, [:model_type, :model_id]
    remove_index :speakers, :seminar_id
  end
end
