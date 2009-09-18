class AddColorAndAcronymToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :color, :string
    add_column :categories, :acronym, :string
  end

  def self.down
    remove_column :categories, :acronym
    remove_column :categories, :color
  end
end
