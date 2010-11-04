require 'test_helper'

class BuildingsControllerTest < ActionController::TestCase
  should route(:get, '/buildings').to(:action => :index)
  should route(:post, '/buildings').to(:action => :create)
  should route(:get, '/buildings/1').to(:action => :show, :id => 1)
  should route(:put, '/buildings/1').to(:action => :update, :id => "1")
  should route(:delete, '/buildings/1').to(:action => :destroy, :id => 1)
  should route(:get, '/buildings/new').to(:action => :new)
  
  context "2 buildings in the database," do
    setup do
      @building1 = Factory :building
      @building2 = Factory :building
    end
    
    context "when not logged_in," do

      context "on :get to :index" do
        setup do
          get :index
        end
        
        should respond_with :success
        should assign_to :buildings
        should render_template :index
      end

      context "on :get to :new" do
        setup do
          get :new
        end
        
        should redirect_to("buildings view") { new_user_session_path }
        should respond_with 302
        should set_the_flash.to('You need to sign in or sign up before continuing.')
      end
    end

    context "when logged_in as basic," do
      setup do
         sign_in users(:basic)
      end

      context "on :get to :index" do
        setup do
          get :index
        end
        
        should respond_with :success
        should assign_to :buildings
        should render_template :index
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should assign_to :building
        should respond_with :success
        should render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end
    end
    
    context "when logged_in as admin," do
      setup do
         sign_in users(:admin)
      end
      
      context "on :get to :index" do
        setup do
          get :index
        end

        should assign_to :buildings
        should respond_with :success
        should render_template :index

        should "assigns to 2 buildings" do
          assert_equal assigns(:buildings).size, 3
        end
      end

      context "on :get to :show with :id  => @building1.id" do
        setup do
          get :show, :id => @building1.id
        end

        should assign_to :building
        should respond_with :success
        should render_template :show

        should "assign to @building" do
          assert_equal assigns(:building), @building1
        end
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should assign_to :building
        should respond_with :success
        should render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :xhr to :new with origin param" do
        setup do
          xhr :get, :new, :origin => 'location'
        end

        should assign_to :building
        should respond_with :success
        should render_template :new
        should_not render_with_layout
        should respond_with_content_type('text/javascript')
      end

      context "on :get to :edit with :id => @building1.id" do
        setup do
          get :edit, :id => @building1.id
        end

        should assign_to :building
        should respond_with :success
        should render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :xhr to :edit with :id => @building1.id" do
        setup do
          xhr :get, :edit, :id => @building1.id
        end

        should assign_to :building
        should render_template :edit
        should_not render_with_layout
      end

      context "on :post to :create with valid params" do
        setup do
          @buildings_count = Building.count
          post :create, :building => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should assign_to :building
        should redirect_to("building view") { building_url(assigns(:building)) }
        should respond_with 302
        
        should "change Building.count :by => 1" do
          assert_equal Building.count-@buildings_count, 1
        end
        should set_the_flash.to(/Building was successfully created/)
      end

      context "on :xhr to :create with valid params" do
        setup do
          @buildings_count = Building.count
          xhr :post, :create, :building => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should assign_to :building
        should respond_with 200
        should render_template 'layouts/insert_in_table'
        
        should "change Building.count :by => 1" do
          assert_equal Building.count-@buildings_count, 1
        end
        should set_the_flash.to(/Building was successfully created/)
      end

      context "on :put to :update with valid params for :id => @building1.id" do
        setup do
          @buildings_count = Building.count
          put :update, :id => @building1.id, :building => {:name => 'CMU new name'}
        end

        should assign_to :building
        should redirect_to("building's show view") { building_url(assigns(:building)) }
        should respond_with 302
        should "change Building.count :by => 0" do
          assert_equal Building.count-@buildings_count, 0
        end
        should 'shange the name of @building to "CMU new name"' do
          assert_equal @building1.reload.name, "CMU new name"
        end
          should set_the_flash.to(/Building was successfully updated/)
      end
      
      context "on :delete to :destroy with  :id => @building1.id" do
        setup do
          @buildings_count = Building.count
          delete :destroy, :id => @building1.id
        end
        
        should "change Building.count :by => -1" do
          assert_equal Building.count-@buildings_count, -1
        end
        should redirect_to("buildings index view") {buildings_url}
        should set_the_flash.to(/Building was successfully deleted/)
      end
    end
  end
end
