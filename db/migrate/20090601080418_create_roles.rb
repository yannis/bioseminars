class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    
    for name in ['basic', 'admin']
      role = Role.create(:name => name)
    end
    
  end

  def self.down
    drop_table :roles
  end
end
