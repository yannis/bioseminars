require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  fixtures :users
  
  def login_as(user)
    @current_user = current_user = users(user)
    @request.session[:user_id] = users(user).id
  end
  
  context "When not logged_in," do
    context "on :get to :index" do
      setup do
        get :index
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end
    
    context "on :get to :show with :id => users(:basic).id" do
      setup do
        get :show, :id => users(:basic).id
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end
    
    context "on :get to :show with :id => users(:admin).id" do
      setup do
        get :show, :id => users(:admin).id
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end
    
    context "on :get to :new" do
      setup do
        get :new
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end
    
    context "on :post to :create with valid params" do
      setup do
        post :create, :user => {:name => 'new user', :email => 'new_user@example.com', :password => 'pass23', :password_confirmation => 'pass23'}
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end

    context "on :get to :edit with :id => users(:basic).id" do
      setup do
        get :edit, :id => users(:basic).id
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end
    
    context "on :get to :edit with :id => users(:admin).id" do
      setup do
        get :edit, :id => users(:admin).id
      end

      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end

    context "on :put to :update with :id => users(:basic.id) and valid params" do
      setup do
        put :update, :id => users(:basic).id, :user => {:name => 'new basic name'}
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
    end
    
    context "on :get to :forgot_password" do
      setup do
        get :forgot_password
      end
      
      should_respond_with :success
      should_render_template :forgot_password
    end
    
    context "on :post to :forgot_password with valid :email" do
      setup do
        post :forgot_password, :user => {:email => 'quentin@example.com'}
      end
      
      should_assign_to :user
      should_redirect_to("login page") { login_url }
      should "assign user to users(:basic)" do
        assert_equal assigns(:user), users(:basic)
      end
      should_set_the_flash_to "A password reset link has been sent to your email address: quentin@example.com"
      should "send an email" do
        assert_sent_email do |mail|
          mail.subject =~ /bioSeminars: Forgotten password/
        end
      end
      should "users(:basic) have a reset_code" do
        assert !users(:basic).reset_code.nil?
      end
      
      context "on :get to reset_password with valid reset_code" do
        setup do
          get :reset_password, :reset_code => users(:basic).reset_code
        end
        
        should_assign_to :user
        should_respond_with :success
        should_render_template :reset_password
        should "assign user to users(:basic)" do
          assert_equal assigns(:user), users(:basic)
        end
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :get to reset_password with invalid reset_code" do
        setup do
          get :reset_password, :reset_code => "invalidCode"
        end

        should_not_assign_to :user
        should_redirect_to("forgot_password_path") { forgot_password_path }
        should_set_the_flash_to "Unable to match reset code."
      end
      
      context "on :post to :reset_password with valid data" do
        setup do
          post :reset_password, :user => {:password => 'newPass', :password_confirmation => 'newPass'}, :reset_code => users(:basic).reset_code
        end
        
        should_assign_to :user
        should_redirect_to("root_path") { root_path }
        should_set_the_flash_to "Password reset successfull."
        should "set the session[:user_id] to users(:basic.id)" do
          assert session[:user_id]
          assert_equal session[:user_id], users(:basic).id
        end
        should "reset the reset_code" do
          assert users(:basic).reload.reset_code.nil?
        end
      end
      
      context "on :post to :reset_password with invalid data" do
        setup do
          post :reset_password, :user => {:password => 'Pass', :password_confirmation => 'newPass'}, :reset_code => users(:basic).reset_code
        end
        
        should_assign_to :user
        should_respond_with :success
        should_render_template :reset_password
        should_set_the_flash_to "Password mismatch."
        should "not set the session[:user_id] to users(:basic.id)" do
          assert !session[:user_id]
          assert_not_equal session[:user_id], users(:basic).id
        end
        should "not reset the reset_code" do
          assert !users(:basic).reload.reset_code.nil?
        end
      end
    end
  end
  
  context "When logged_in as :basic," do
    setup do
      login_as(:basic)
    end
    
    context "on :get to :index" do
      setup do
        get :index
      end
      
      should_redirect_to("login page") { new_session_url }
      should_respond_with 302
      should_set_the_flash_to "No credentials."
    end
    
    context "on :get to :show with :id => users(:basic).id" do
      setup do
        get :show, :id => users(:basic).id
      end
      
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
      should "assign user to users(:basic)" do
        assert_equal assigns(:user), users(:basic)
      end
    end
    
    context "on :get to :show with :id => users(:admin).id" do
      setup do
        get :show, :id => users(:admin).id
      end

      should_redirect_to("home") { root_url }
      should_set_the_flash_to "User not found."
    end
    
    context "on :get to :new" do
      setup do
        get :new
      end

      should_redirect_to("login page") { new_session_url }
      should_set_the_flash_to "No credentials."
    end
    
    context "on :post to :create with valid params" do
      setup do
        post :create, :user => {:name => 'new user', :email => 'new_user@example.com', :password => 'pass23', :password_confirmation => 'pass23'}
      end

      should_redirect_to("login page") { new_session_url }
      should_set_the_flash_to "No credentials."
    end

    context "on :get to :edit with :id => users(:basic).id" do
      setup do
        get :edit, :id => users(:basic).id
      end

      should_assign_to :user
      should_respond_with :success
      should_render_template :edit
      should "assign user to users(:basic)" do
        assert_equal assigns(:user), users(:basic)
      end
    end
    
    context "on :get to :edit with :id => users(:admin).id" do
      setup do
        get :edit, :id => users(:admin).id
      end

      should_redirect_to("home") { root_url }
      should_set_the_flash_to "User not found."
    end

    context "on :put to :update with :id => users(:basic.id) and valid params" do
      setup do
        put :update, :id => users(:basic).id, :user => {:name => 'new basic name'}
      end

      should_assign_to :user
      should_redirect_to("basic user show page") { user_url(users(:basic)) }
      should "assign user to users(:basic)" do
        assert_equal assigns(:user), users(:basic)
      end
      should_set_the_flash_to "User was successfully updated."
    end
      
      # should_assign_to :seminar
      #       should_redirect_to("seminar's show view") { seminar_url(assigns(:seminar)) }
      #       should_respond_with 302
      #       should_change("the number of seminars", :by => 1) { Seminar.count }
      #       should_change("the number of speakers", :by => 1) { Speaker.count }
      #       should_change("the number of hosts", :by => 1) { Host.count }
      #       should_set_the_flash_to "Seminar was successfully created."
    
  end

  # def test_should_allow_signup
  #   assert_difference 'User.count' do
  #     create_user
  #     assert_response :redirect
  #   end
  # end
  # 
  # def test_should_require_login_on_signup
  #   assert_no_difference 'User.count' do
  #     create_user(:login => nil)
  #     assert assigns(:user).errors.on(:login)
  #     assert_response :success
  #   end
  # end
  # 
  # def test_should_require_password_on_signup
  #   assert_no_difference 'User.count' do
  #     create_user(:password => nil)
  #     assert assigns(:user).errors.on(:password)
  #     assert_response :success
  #   end
  # end
  # 
  # def test_should_require_password_confirmation_on_signup
  #   assert_no_difference 'User.count' do
  #     create_user(:password_confirmation => nil)
  #     assert assigns(:user).errors.on(:password_confirmation)
  #     assert_response :success
  #   end
  # end
  # 
  # def test_should_require_email_on_signup
  #   assert_no_difference 'User.count' do
  #     create_user(:email => nil)
  #     assert assigns(:user).errors.on(:email)
  #     assert_response :success
  #   end
  # end
  

  

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
