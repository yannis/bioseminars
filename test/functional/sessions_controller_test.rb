require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase

  fixtures :all
  
  should_route :get, '/session/new', :action => :new
  should_route :post, '/session', :action => :create
  should_route :delete, '/session', :action => :destroy
  
  def login_as(user)
    @current_user = current_user = users(user)
    @request.session[:user_id] = users(user).id
  end
  
  context "on :post to :create with :email => 'quentin@example.com' and :password => 'monkey'" do
    setup do
      post :create, :email => 'quentin@example.com', :password => 'monkey'
    end
    
    should "set the session[:user_id] to users(:basic.id)" do
      assert session[:user_id]
      assert_equal session[:user_id], users(:basic).id
    end
    should_redirect_to("seminars/index") { root_url }
  end
  
  context "on :post to :create with :email => 'quentin@example.com' and :password => 'bad password'" do
    setup do
      post :create, :email => 'quentin@example.com', :password => 'bad password'
    end
    
    should "set the session[:user_id] to users(:basic.id)" do
      assert_nil session[:user_id]
    end
    should_respond_with :success
    should_render_template :new
  end
  
  context "When logged_in as :basic, on :get to :destroy," do
    setup do
      login_as(:basic)
      get :destroy
    end
    
    should "set the session[:user_id] to users(:basic.id)" do
      assert_nil session[:user_id]
    end
    should_redirect_to("seminars/index") { root_url }
  end
  
  context "When remember_me is checked on login," do
    setup do
      @request.cookies["auth_token"] = nil
      post :create, :email => 'quentin@example.com', :password => 'monkey', :remember_me => "1"
    end
    should "create a cookie auth_token" do
      assert_not_nil @response.cookies["auth_token"]
    end
    
    context "on logout" do
      setup do
        get :destroy
      end
      
      should 'the auth_token be deleted' do
        assert @response.cookies["auth_token"].nil?
      end
    end
  end
  
  context "When remember_me is not checked on login," do
    setup do
      @request.cookies["auth_token"] = nil
      post :create, :email => 'quentin@example.com', :password => 'monkey', :remember_me => "0"
    end
    should "not create a cookie auth_token" do
      # puts @response.cookies["auth_token"]
      assert @response.cookies["auth_token"].nil?
    end
  end
  
  context "If the auth_token cookie exists, on login it" do
    setup do
      users(:basic).remember_me
      @request.cookies["auth_token"] = cookie_for(:basic)
      get :new
    end
    
    should 'be used' do
      assert @controller.send(:logged_in?)
      assert_equal session[:user_id], users(:basic).id
    end
  end
  
  context 'If the auth_token cookie exists but is expired,' do
    setup do
      users(:basic).remember_me
      users(:basic).update_attribute :remember_token_expires_at, 5.minutes.ago
      @request.cookies["auth_token"] = cookie_for(:basic)
      get :new
    end
  
    should 'login fail' do
      assert !@controller.send(:logged_in?)
    end
  end
    
  context 'If the auth_token cookie exists but contains a false auth_token,' do
    setup do
      users(:basic).remember_me
      @request.cookies["auth_token"] = auth_token('invalid_auth_token')
      get :new
    end
  
    should 'login fail' do
      assert !@controller.send(:logged_in?)
    end
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
    
    # def test_should_login_and_redirect
    #     post :create, :login => 'quentin', :password => 'monkey'
    #     assert session[:user_id]
    #     assert_response :redirect
    #   end
    # 
    #   def test_should_fail_login_and_not_redirect
    #     post :create, :login => 'quentin', :password => 'bad password'
    #     assert_nil session[:user_id]
    #     assert_response :success
    #   end
    # 
    #   def test_should_logout
    #     login_as :quentin
    #     get :destroy
    #     assert_nil session[:user_id]
    #     assert_response :redirect
    #   end
    # 
    #   def test_should_remember_me
    #     @request.cookies["auth_token"] = nil
    #     post :create, :login => 'quentin', :password => 'monkey', :remember_me => "1"
    #     assert_not_nil @response.cookies["auth_token"]
    #   end
    # 
    #   def test_should_not_remember_me
    #     @request.cookies["auth_token"] = nil
    #     post :create, :login => 'quentin', :password => 'monkey', :remember_me => "0"
    #     puts @response.cookies["auth_token"]
    #     assert @response.cookies["auth_token"].blank?
    #   end#   
    #   def test_should_delete_token_on_logout
    #     login_as :quentin
    #     get :destroy
    #     assert @response.cookies["auth_token"].blank?
    #   end
    
    # 
    #   def test_should_login_with_cookie
    #     users(:quentin).remember_me
    #     @request.cookies["auth_token"] = cookie_for(:quentin)
    #     get :new
    #     assert @controller.send(:logged_in?)
    #   end
    
    # 
    #   def test_should_fail_expired_cookie_login
    #     users(:quentin).remember_me
    #     users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    #     @request.cookies["auth_token"] = cookie_for(:quentin)
    #     get :new
    #     assert !@controller.send(:logged_in?)
    #   end
    # 
    #   def test_should_fail_cookie_login
    #     users(:quentin).remember_me
    #     @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    #     get :new
    #     assert !@controller.send(:logged_in?)
    #   end
end
