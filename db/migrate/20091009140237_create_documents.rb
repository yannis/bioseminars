class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :model_type, :null => false
      t.integer :model_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
