require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  should route(:get, '/categories').to(:action => :index)
  should route(:post, '/categories').to(:action => :create)
  should route(:get, '/categories/1').to(:action => :show, :id => 1)
  should route(:put, '/categories/1').to(:action => :update, :id => "1")
  should route(:delete, '/categories/1').to(:action => :destroy, :id => 1)
  should route(:get, '/categories/new').to(:action => :new)
  
  context "2 categories in the database," do
    setup do
      @category1 = Category.create(:name => "cat1")
      @category2 = Category.create(:name => "cat2")
    end
    
    context "when not logged in," do

      context "on :get to :index" do
        setup do
          get :index
        end

        should assign_to :categories
        should respond_with :success
        should render_template :index
      end
      
      context "on :get to :show with :id  => @category1.id" do
        setup do
          get :show, :id => @category1.id
        end

        should assign_to :category
        should respond_with :success
        should render_template :show
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :get to :edit with :id => @category1.id" do
        setup do
          get :edit, :id => @category1.id
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :post to :create with valid params" do
        setup do
          post :create, :category => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :put to :update with valid params for :id => @category1.id" do
        setup do
          put :update, :id => @category1.id, :category => {:name => 'CMU new name'}
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :delete to :destroy with  :id => @category1.id" do
        setup do
          delete :destroy, :id => @category1.id
        end

        should redirect_to("login form") { '/users/sign_in' }
      end
    end
    
    context "when logged in as :basic," do
      setup do
        sign_in users(:basic)
      end

      context "on :get to :index" do
        setup do
          get :index
        end

        should assign_to :categories
        should respond_with :success
        should render_template :index
      end
      
      context "on :get to :show with :id  => @category1.id" do
        setup do
          get :show, :id => @category1.id
        end

        should assign_to :category
        should respond_with :success
        should render_template :show
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should redirect_to("root path") { root_path }
      end

      context "on :get to :edit with :id => @category1.id" do
        setup do
          get :edit, :id => @category1.id
        end

        should redirect_to("root path") { root_path }
      end

      context "on :post to :create with valid params" do
        setup do
          post :create, :category => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should redirect_to("root path") { root_path }
      end

      context "on :put to :update with valid params for :id => @category1.id" do
        setup do
          put :update, :id => @category1.id, :category => {:name => 'CMU new name'}
        end

        should redirect_to("root path") { root_path }
      end

      context "on :delete to :destroy with  :id => @category1.id" do
        setup do
          delete :destroy, :id => @category1.id
        end

        should redirect_to("root path") { root_path }
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

        should assign_to :categories
        should respond_with :success
        should render_template :index

        should "assigns to 2 categories" do
          assert_equal assigns(:categories).size, 3
        end

      end

      context "on :get to :show with :id  => @category1.id" do
        setup do
          get :show, :id => @category1.id
        end

        should assign_to :category
        should respond_with :success
        should render_template :show

        should "assign to @category" do
          assert_equal assigns(:category), @category1
        end
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should assign_to :category
        should respond_with :success
        should render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :get to :edit with :id => @category1.id" do
        setup do
          get :edit, :id => @category1.id
        end

        should assign_to :category
        should respond_with :success
        should render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :post to :create with valid params" do
        setup do
          @categories_count = Category.count
          post :create, :category => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should assign_to :category
        should redirect_to("categories page") { categories_url }
        should respond_with 302
        should "change Category.count by 1" do
          assert_equal Category.count-@categories_count, 1
        end
        should set_the_flash.to("Category was successfully created")
      end

      context "on :put to :update with valid params for :id => @category1.id" do
        setup do
          @categories_count = Category.count
          put :update, :id => @category1.id, :category => {:name => 'CMU new name'}
        end

        should assign_to :category
        should redirect_to("category's show view") { category_url(assigns(:category)) }
        should respond_with 302
        should "change Category.count by 0" do
          assert_equal Category.count-@categories_count, 0
        end
        should 'shange the name of @category to "CMU new name"' do
          assert_equal @category1.reload.name, "CMU new name"
        end
          should set_the_flash.to("Category successfully updated")
      end
      
      context "on :delete to :destroy with  :id => @category1.id" do
        setup do
          @categories_count = Category.count
          delete :destroy, :id => @category1.id
        end
        
        should "change Category.count by -1" do
          assert_equal Category.count-@categories_count, -1
        end
        should redirect_to("categories index view") {categories_url}
        should set_the_flash.to("Category was successfully deleted")
      end
    end
  end
end
