require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  fixtures :all
  
  def login_as(user)
    @current_user = current_user = users(user)
    @request.session[:user_id] = users(user).id
  end
  
  should_route :get, '/locations', :action => :index
  should_route :post, '/locations', :action => :create
  should_route :get, '/locations/1', :action => :show, :id => 1
  should_route :put, '/locations/1', :action => :update, :id => "1"
  should_route :delete, '/locations/1', :action => :destroy, :id => 1
  should_route :get, '/locations/new', :action => :new
  
  context "2 locations in the database," do
    setup do
      @location1 = Location.create(:name => "SCII")
      @location2 = Location.create(:name => "SCIII")
    end

    context "when logged_in as basic," do
      setup do
        login_as(:basic)
      end
      
      context "on :get to :index" do
        setup do
          get :index
        end

        should_assign_to :locations
        should_respond_with :success
        should_render_template :index

        should "assigns to 2 locations" do
          assert_equal assigns(:locations).size, 3
        end
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

        should_assign_to :locations
        should_respond_with :success
        should_render_template :index

        should "assigns to 2 locations" do
          assert_equal assigns(:locations).size, 3
        end
      end

      context "on :get to :show with :id  => @location1.id" do
        setup do
          get :show, :id => @location1.id
        end

        should_assign_to :location
        should_respond_with :success
        should_render_template :show

        should "assign to @location" do
          assert_equal assigns(:location), @location1
        end
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should_assign_to :location
        should_respond_with :success
        should_render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :get to :edit with :id => @location1.id" do
        setup do
          get :edit, :id => @location1.id
        end

        should_assign_to :location
        should_respond_with :success
        should_render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :post to :create with valid params" do
        setup do
          post :create, :location => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should_assign_to :location
        should_redirect_to("location's show view") { location_url(assigns(:location)) }
        should_respond_with 302
        should_change("the number of locations", :by => 1) { Location.count }
        should_set_the_flash_to "Location was successfully created."
      end

      context "on :put to :update with valid params for :id => @location1.id" do
        setup do
          put :update, :id => @location1.id, :location => {:name => 'CMU new name'}
        end

        should_assign_to :location
        should_redirect_to("location's show view") { location_url(assigns(:location)) }
        should_respond_with 302
        should_change("the number of locations", :by => 0) { Location.count }
        should 'shange the name of @location to "CMU new name"' do
          assert_equal @location1.reload.name, "CMU new name"
        end
          should_set_the_flash_to "Location was successfully updated."
      end
      
      context "on :delete to :destroy with  :id => @location1.id" do
        setup do
          delete :destroy, :id => @location1.id
        end
        
        should_change("the number of locations", :by => -1) { Location.count }
        should_redirect_to("locations index view") {locations_url}
        should_set_the_flash_to "Location was successfully deleted."
      end
    end
  end
end
