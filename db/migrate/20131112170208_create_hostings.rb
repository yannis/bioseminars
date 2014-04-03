class CreateHostings < ActiveRecord::Migration
  def change
    create_table :hostings do |t|
      t.integer :host_id
      t.integer :seminar_id

      t.timestamps
    end
  end
end
