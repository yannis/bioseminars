require 'test_helper'

# Re-raise errors caught by the controller.
# class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  
  context "When not logged_in," do
    context "on :get to :index" do
      setup do
        get :index
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end
    
    context "on :get to :show with :id => users(:basic).id" do
      setup do
        get :show, :id => users(:basic).id
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end
    
    context "on :get to :show with :id => users(:admin).id" do
      setup do
        get :show, :id => users(:admin).id
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end
    
    context "on :get to :new" do
      setup do
        get :new
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end
    
    context "on :post to :create with valid params" do
      setup do
        post :create, :user => {:name => 'new user', :email => 'new_user@example.com', :password => 'pass23', :password_confirmation => 'pass23'}
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end

    context "on :get to :edit with :id => users(:basic).id" do
      setup do
        get :edit, :id => users(:basic).id
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end
    
    context "on :get to :edit with :id => users(:admin).id" do
      setup do
        get :edit, :id => users(:admin).id
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end

    context "on :put to :update with :id => users(:basic.id) and valid params" do
      setup do
        put :update, :id => users(:basic).id, :user => {:name => 'new basic name'}
      end
      
      should redirect_to("sign_in path") { new_user_session_path }
      should respond_with 302
    end
  end
  
  context "When logged_in as :basic," do
    setup do
      sign_in users(:basic)
    end
    
    context "on :get to :index" do
      setup do
        get :index
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end
    
    context "on :get to :show with :id => users(:basic).id" do
      setup do
        get :show, :id => users(:basic).id
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end
    
    context "on :get to :show with :id => users(:admin).id" do
      setup do
        get :show, :id => users(:admin).id
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end
    
    context "on :get to :new" do
      setup do
        get :new
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end
    
    context "on :post to :create with valid params" do
      setup do
        post :create, :user => {:name => 'new user', :email => 'new_user@example.com', :password => 'pass23', :password_confirmation => 'pass23'}
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end

    context "on :get to :edit with :id => users(:basic).id" do
      setup do
        get :edit, :id => users(:basic).id
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end
    
    context "on :get to :edit with :id => users(:admin).id" do
      setup do
        get :edit, :id => users(:admin).id
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end

    context "on :put to :update with :id => users(:basic.id) and valid params" do
      setup do
        put :update, :id => users(:basic).id, :user => {:name => 'new basic name'}
      end
      
      should redirect_to("root path") { root_path }
      should respond_with 302
      should set_the_flash.to("You are not authorized to access this page.")
    end
  end
end
