require 'test_helper'

class BuildingsControllerTest < ActionController::TestCase
  fixtures :all
  
  def login_as(user)
    @current_user = current_user = users(user)
    @request.session[:user_id] = users(user).id
  end
  
  should_route :get, '/buildings', :action => :index
  should_route :post, '/buildings', :action => :create
  should_route :get, '/buildings/1', :action => :show, :id => 1
  should_route :put, '/buildings/1', :action => :update, :id => "1"
  should_route :delete, '/buildings/1', :action => :destroy, :id => 1
  should_route :get, '/buildings/new', :action => :new
  
  context "2 buildings in the database," do
    setup do
      @building1 = Building.create(:name => "SCII")
      @building2 = Building.create(:name => "SCIII")
    end

    context "when logged_in as basic," do
      setup do
        login_as(:basic)
      end

      context "on :get to :index" do
        setup do
          get :index
        end
        should_redirect_to("login form") { new_session_url }
        should_set_the_flash_to "No credentials."
      end
    end
    
    context "when logged_in as admin," do
      setup do
        login_as(:admin)
      end
      
      context "on :get to :index" do
        setup do
          get :index
        end

        should_assign_to :buildings
        should_respond_with :success
        should_render_template :index

        should "assigns to 2 buildings" do
          assert_equal assigns(:buildings).size, 3
        end
      end

      context "on :get to :show with :id  => @building1.id" do
        setup do
          get :show, :id => @building1.id
        end

        should_assign_to :building
        should_respond_with :success
        should_render_template :show

        should "assign to @building" do
          assert_equal assigns(:building), @building1
        end
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should_assign_to :building
        should_respond_with :success
        should_render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :get to :edit with :id => @building1.id" do
        setup do
          get :edit, :id => @building1.id
        end

        should_assign_to :building
        should_respond_with :success
        should_render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :post to :create with valid params" do
        setup do
          post :create, :building => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should_assign_to :building
        should_redirect_to("building's show view") { building_url(assigns(:building)) }
        should_respond_with 302
        should_change("the number of buildings", :by => 1) { Building.count }
        should_set_the_flash_to "Building was successfully created."
      end

      context "on :put to :update with valid params for :id => @building1.id" do
        setup do
          put :update, :id => @building1.id, :building => {:name => 'CMU new name'}
        end

        should_assign_to :building
        should_redirect_to("building's show view") { building_url(assigns(:building)) }
        should_respond_with 302
        should_change("the number of buildings", :by => 0) { Building.count }
        should 'shange the name of @building to "CMU new name"' do
          assert_equal @building1.reload.name, "CMU new name"
        end
          should_set_the_flash_to "Building was successfully updated."
      end
      
      context "on :delete to :destroy with  :id => @building1.id" do
        setup do
          delete :destroy, :id => @building1.id
        end
        
        should_change("the number of buildings", :by => -1) { Building.count }
        should_redirect_to("buildings index view") {buildings_url}
        should_set_the_flash_to "Building was successfully deleted."
      end
    end
  end
end
