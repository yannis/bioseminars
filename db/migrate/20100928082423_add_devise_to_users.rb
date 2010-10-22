class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean
    for user in User.all
      user.update_attribute(:admin, true) if user.role_id == 2
    end
    add_column :users, :persistence_token, :string
    add_column :users, :reset_password_token, :string
    add_column :users, :remember_created_at, :datetime
    add_column :users, :sign_in_count, :integer
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
    rename_column :users, :crypted_password, :encrypted_password
    rename_column :users, :salt, :password_salt
    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true
    remove_column :users, :role_id
    drop_table :roles
  end

  def self.down
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    for name in ['basic', 'admin']
      Role.create(:name => name)
    end
    add_column :users, :role_id, :integer
    for user in User.all
      user.update_attribute(:role_id, (user.admin == true ? 2 : 1))
    end
    remove_column :users, :admin, :boolean
    remove_column :users, :persistence_token, :string
    remove_column :users, :reset_password_token, :string
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string
    rename_column :users, :encrypted_password, :crypted_password
    rename_column :users, :password_salt, :salt
    remove_index :users, :email
    remove_index :users, :reset_password_token
  end
end
