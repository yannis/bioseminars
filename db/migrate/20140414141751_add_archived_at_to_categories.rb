class AddArchivedAtToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :archived_at, :datetime
    add_index :categories, :archived_at
  end
end
