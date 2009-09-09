class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :name, :limit => 100, :null => false
      t.string :email, :limit => 100, :null => false
      t.integer :role_id, :integer
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
    user = User.new(:name => 'Yannis', :email => 'yannis.jaquet@unige.ch', :password => 'seminars2375', :password_confirmation => 'seminars2375')
    user.role = Role.find_by_name('admin')
    unless user.save
      raise user.errors.inspect
    end    
  end

  def self.down
    drop_table "users"
  end
end
