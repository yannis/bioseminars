require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :roles
  
  should_belong_to :role
  should_have_many :seminars, :dependent => :destroy
  
  should_validate_presence_of :name, :email, :password, :password_confirmation
  should_ensure_length_in_range :name, (3..100)
  should_validate_uniqueness_of :email
  should_ensure_length_in_range :email, (6..100)
  
  should_allow_mass_assignment_of :email, :name, :password, :password_confirmation, :role_id
  
  should_have_named_scope("all_for_user(User.find_by_name('basic'))", {:conditions => ["users.id = ?", 1]})
  should_have_named_scope("all_for_user(User.find_by_name('admin'))")


  context "A new user with no role," do
    setup do
      @user = User.create(:email => 'user@example.com', :name => 'user name', :password => 'quire69', :password_confirmation => 'quire69')
    end
    
    should 'have his role set to :basic' do
      assert_equal @user.role.name, 'basic'
    end
    
    should 'have his role_id set to 1' do
      assert_equal @user.role_id, 1
    end
    
    should 'be valid' do
      assert @user.valid?, @user.errors.full_messages.to_sentence
    end
    
    should_change("the number of users", :by => 1) { User.count }
    
    should 'authenticate_user' do
      assert_equal @user, User.authenticate('user@example.com', 'quire69')
    end
  end
  
  context "A new user with extravagant role_id," do
    setup do
      @user = User.create(:email => 'user@example.com', :name => 'user name', :password => 'quire69', :password_confirmation => 'quire69', :role_id => -554546564)
    end
    
    should 'have his role set to :basic' do
      assert_equal @user.role.name, 'basic'
    end
    
    should 'have his role_id set to 1' do
      assert_equal @user.role_id, 1
    end
    
    should 'be valid' do
      assert @user.valid?, @user.errors.full_messages.to_sentence
    end
    
    should_change("the number of users", :by => 1) { User.count }
  end
  
  context "A new user with role set to :admin," do
    setup do
      @user = User.create(:email => 'user@example.com', :name => 'user name', :password => 'quire69', :password_confirmation => 'quire69', :role_id => Role.find_by_name('admin').id)
    end
    
    should 'have his role set to :admin' do
      assert_equal @user.role.name, 'admin'
    end
    
    should 'have his role_id set to 2' do
      assert_equal @user.role_id, 2
    end
    
    should 'be valid' do
      assert @user.valid?, @user.errors.full_messages.to_sentence
    end
    
    should_change("the number of users", :by => 1) { User.count }
    
    context 'with a new password' do
      setup do
        @user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      end
      
      should 'be valid' do
        assert @user.valid?, @user.errors.full_messages.to_sentence
      end
      
      should 'have password == "new password"' do
        assert_equal @user.password, "new password"
      end
      
      should 'allows authentication of @user' do
        assert_equal @user, User.authenticate('user@example.com', 'new password')
      end
    end
    
    context 'with a new email' do
      setup do
        @user.update_attributes(:email => 'email2@example.com')
      end
      
      should 'be valid' do
        assert @user.valid?, @user.errors.full_messages.to_sentence
      end
      
      should 'not change password' do
        assert_equal @user, User.authenticate('email2@example.com', 'quire69')
      end
    end
    
    context 'if remember_me is set,' do
      setup do
        @user.remember_me
      end
      
      should 'set the remember_me token' do
        assert_not_nil @user.remember_token
      end
      
      should 'set the remember_token_expires_at datetime' do
        assert_not_nil @user.remember_token_expires_at
        assert_equal @user.remember_token_expires_at.beginning_of_day, 2.weeks.from_now.beginning_of_day
      end
      
      context 'if forget_me is set,' do
        setup do
          @user.forget_me
        end
        
        should 'remove the remember_me token' do
          assert_nil @user.remember_token
          assert_nil @user.remember_token_expires_at
        end
      end
    end
  end


  # def test_should_create_user
  #   assert_difference 'User.count' do
  #     user = create_user
  #     assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
  #   end
  # end
  # 
  # def test_should_require_login
  #   assert_no_difference 'User.count' do
  #     u = create_user(:login => nil)
  #     assert u.errors.on(:login)
  #   end
  # end
  # 
  # def test_should_require_password
  #   assert_no_difference 'User.count' do
  #     u = create_user(:password => nil)
  #     assert u.errors.on(:password)
  #   end
  # end
  # 
  # def test_should_require_password_confirmation
  #   assert_no_difference 'User.count' do
  #     u = create_user(:password_confirmation => nil)
  #     assert u.errors.on(:password_confirmation)
  #   end
  # end
  # 
  # def test_should_require_email
  #   assert_no_difference 'User.count' do
  #     u = create_user(:email => nil)
  #     assert u.errors.on(:email)
  #   end
  # end
  # 
  # def test_should_reset_password
  #   users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
  #   assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  # end
  # 
  # def test_should_not_rehash_password
  #   users(:quentin).update_attributes(:login => 'quentin2')
  #   assert_equal users(:quentin), User.authenticate('quentin2', 'monkey')
  # end
  # 
  # def test_should_authenticate_user
  #   assert_equal users(:quentin), User.authenticate('quentin', 'monkey')
  # end
  # 
  # def test_should_set_remember_token
  #   users(:quentin).remember_me
  #   assert_not_nil users(:quentin).remember_token
  #   assert_not_nil users(:quentin).remember_token_expires_at
  # end
  # 
  # def test_should_unset_remember_token
  #   users(:quentin).remember_me
  #   assert_not_nil users(:quentin).remember_token
  #   users(:quentin).forget_me
  #   assert_nil users(:quentin).remember_token
  # end
  # 
  # def test_should_remember_me_for_one_week
  #   before = 1.week.from_now.utc
  #   users(:quentin).remember_me_for 1.week
  #   after = 1.week.from_now.utc
  #   assert_not_nil users(:quentin).remember_token
  #   assert_not_nil users(:quentin).remember_token_expires_at
  #   assert users(:quentin).remember_token_expires_at.between?(before, after)
  # end
  # 
  # def test_should_remember_me_until_one_week
  #   time = 1.week.from_now.utc
  #   users(:quentin).remember_me_until time
  #   assert_not_nil users(:quentin).remember_token
  #   assert_not_nil users(:quentin).remember_token_expires_at
  #   assert_equal users(:quentin).remember_token_expires_at, time
  # end
  # 
  # def test_should_remember_me_default_two_weeks
  #   before = 2.weeks.from_now.utc
  #   users(:quentin).remember_me
  #   after = 2.weeks.from_now.utc
  #   assert_not_nil users(:quentin).remember_token
  #   assert_not_nil users(:quentin).remember_token_expires_at
  #   assert users(:quentin).remember_token_expires_at.between?(before, after)
  # end

# protected
#   def create_user(options = {})
#     record = User.new({:email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
#     record.save
#     record
#   end
end
