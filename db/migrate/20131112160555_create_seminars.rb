class CreateSeminars < ActiveRecord::Migration
  def change
    create_table :seminars do |t|
      t.string :title
      t.text :description
      t.string :speaker_name
      t.string :speaker_affiliation
      t.datetime :start_at
      t.datetime :end_at
      t.string :url
      t.belongs_to :location, index: true
      t.belongs_to :user, index: true
      t.boolean :all_day
      t.boolean :internal
      t.string :pubmed_ids

      t.timestamps
    end
  end
end
