require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  
  should route(:get, '/locations').to( :action => :index)
  should route(:post, '/locations').to( :action => :create)
  should route(:get, '/locations/1').to( :action => :show, :id => 1)
  should route(:put, '/locations/1').to( :action => :update, :id => "1")
  should route(:delete, '/locations/1').to( :action => :destroy, :id => 1)
  should route(:get, '/locations/new').to( :action => :new)
  
  context "2 locations in the database," do
    setup do
      @location1 = Factory :location
      @location2 = Factory :location
    end
    
    context "when not logged in" do

      context "on :get to :index" do
        setup do
          get :index
        end

        should assign_to :locations
        should respond_with :success
        should render_template :index
      end
      
      context "on :get to :show with :id  => @location1.id" do
        setup do
          get :show, :id => @location1.id
        end

        should assign_to :location
        should respond_with :success
        should render_template :show
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :get to :edit with :id => @location1.id" do
        setup do
          get :edit, :id => @location1.id
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :post to :create with valid params" do
        setup do
          post :create, :location => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :put to :update with valid params for :id => @location1.id" do
        setup do
          put :update, :id => @location1.id, :location => {:name => 'CMU new name'}
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :delete to :destroy with  :id => @location1.id" do
        setup do
          delete :destroy, :id => @location1.id
        end

        should redirect_to("login form") { '/users/sign_in' }
      end
    end
    
    for status in ['basic', 'admin'] do
      context "when logged_in as #{status}," do
        setup do
          sign_in users(status.to_sym)
        end
      
        context "on :get to :index" do
          setup do
            get :index
          end
    
          should assign_to :locations
          should respond_with :success
          should render_template :index
    
          should "assigns to 2 locations" do
            assert_equal assigns(:locations).size, 3
          end
        end
    
        context "on :get to :show with :id  => @location1.id" do
          setup do
            get :show, :id => @location1.id
          end
    
          should assign_to :location
          should respond_with :success
          should render_template :show
    
          should "assign to @location" do
            assert_equal assigns(:location), @location1
          end
        end
    
        context "on :get to :new" do
          setup do
            get :new
          end
    
          should assign_to :location
          should respond_with :success
          should render_template :new
          should "display a form" do
            assert_select "form", true, "The template doesn't contain a <form> element"
          end
        end
    
        context "on :get to :edit with :id => @location1.id" do
          setup do
            get :edit, :id => @location1.id
          end
    
          should assign_to :location
          should respond_with :success
          should render_template :edit
          should "display a form" do
            assert_select "form", true, "The template doesn't contain a <form> element"
          end
        end
    
        context "on :post to :create with valid params" do
          setup do
            @location_count = Location.count
            post :create, :location => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
          end
    
          should assign_to :location
          should redirect_to("location's show view") { location_url(assigns(:location)) }
          should respond_with 302
          should "change Location.count by 1" do
            assert_equal Location.count-@location_count, 1
          end
          should set_the_flash.to("Location was successfully created")
        end
    
        context "on :put to :update with valid params for :id => @location1.id" do
          setup do
            @location_count = Location.count
            put :update, :id => @location1.id, :location => {:name => 'CMU new name'}
          end
    
          should assign_to :location
          should redirect_to("location's show view") { location_url(assigns(:location)) }
          should respond_with 302
          should "change Location.count by 0" do
            assert_equal Location.count-@location_count, 0
          end
          should 'shange the name of @location to "CMU new name"' do
            assert_equal @location1.reload.name, "CMU new name"
          end
            should set_the_flash.to(/Location was successfully updated/)
        end
      
        context "on :delete to :destroy with  :id => @location1.id" do
          setup do
            @location_count = Location.count
            delete :destroy, :id => @location1.id
          end
        
          should "change Location.count by -1" do
            assert_equal Location.count-@location_count, -1
          end
          should redirect_to("locations index view") {locations_url}
          should set_the_flash.to("Location was successfully deleted.")
        end
      end
    end
  end
end
