require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
    
  should have_many(:seminars).dependent(:destroy)
  
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_presence_of(:password)
  should validate_format_of(:name).with('Yannis Jaquet')
  should ensure_length_of(:name).is_at_least(5).is_at_most(100)
  should validate_uniqueness_of :email
  should allow_mass_assignment_of :email
  should allow_mass_assignment_of :name
  should allow_mass_assignment_of :password
  should allow_mass_assignment_of :password_confirmation
  
  # should "have scope all_for_user" do
  #   assert_equal User.all_for_user(User.find_by_name('basic')), User.where(:id => 1)
  #   assert_equal User.all_for_user(User.find_by_name('admin')), User.all
  # end

  context "A new user with no role," do
    setup do
      @user_count = User.count
      @user = Factory :user, :name => "Yannis Jaquet"
    end
    
    should 'not be an admin' do
      assert !@user.admin?
    end
    
    should 'have his nickname == user' do
      assert_equal @user.nickname, 'Y.Jaquet'
    end
    
    should 'be valid' do
      assert @user.valid?, @user.errors.full_messages.to_sentence
    end
    
    should "change User.count by 1" do
      assert_equal User.count-@user_count, 1
    end
  end
  
  context "A new user with role set to :admin," do
    setup do
      @user_count = User.count
      @user = User.create(:email => 'user@example.com', :name => 'user name', :password => 'quire69', :password_confirmation => 'quire69', :admin => true)
    end
    
    should 'have his role set to :admin' do
      assert @user.admin?
    end
    
    should 'be valid' do
      assert @user.valid?, @user.errors.full_messages.to_sentence
    end
    
    should "change User.count by 1" do
      assert_equal User.count-@user_count, 1
    end
    
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
    end
    
    context 'with a new email' do
      setup do
        @user.update_attributes(:email => 'email2@example.com')
      end
      
      should 'be valid' do
        assert @user.valid?, @user.errors.full_messages.to_sentence
      end
    end
  end
end
