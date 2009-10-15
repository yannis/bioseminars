class AddPubmedIdsToSeminars < ActiveRecord::Migration
  def self.up
    add_column :seminars, :pubmed_ids, :string
  end

  def self.down
    remove_column :seminars, :pubmed_ids
  end
end
