class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :color
      t.string :acronym
      t.integer :position

      t.timestamps
    end
  end
end
