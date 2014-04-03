class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :documentable, polymorphic: true, index: true
      t.attachment :data

      t.timestamps
    end
  end
end
