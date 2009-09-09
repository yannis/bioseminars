require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  fixtures :all
  
  def login_as(user)
    @current_user = current_user = users(user)
    @request.session[:user_id] = users(user).id
  end
  
  should_route :get, '/categories', :action => :index
  should_route :post, '/categories', :action => :create
  should_route :get, '/categories/1', :action => :show, :id => 1
  should_route :put, '/categories/1', :action => :update, :id => "1"
  should_route :delete, '/categories/1', :action => :destroy, :id => 1
  should_route :get, '/categories/new', :action => :new
  
  context "2 categories in the database," do
    setup do
      @category1 = Category.create(:name => "cat1")
      @category2 = Category.create(:name => "cat2")
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

        should_assign_to :categories
        should_respond_with :success
        should_render_template :index

        should "assigns to 2 categories" do
          assert_equal assigns(:categories).size, 3
        end

      end

      context "on :get to :show with :id  => @category1.id" do
        setup do
          get :show, :id => @category1.id
        end

        should_assign_to :category
        should_respond_with :success
        should_render_template :show

        should "assign to @category" do
          assert_equal assigns(:category), @category1
        end
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should_assign_to :category
        should_respond_with :success
        should_render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :get to :edit with :id => @category1.id" do
        setup do
          get :edit, :id => @category1.id
        end

        should_assign_to :category
        should_respond_with :success
        should_render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :post to :create with valid params" do
        setup do
          post :create, :category => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should_assign_to :category
        should_redirect_to("category's show view") { category_url(assigns(:category)) }
        should_respond_with 302
        should_change("the number of categories", :by => 1) { Category.count }
        should_set_the_flash_to "Category was successfully created."
      end

      context "on :put to :update with valid params for :id => @category1.id" do
        setup do
          put :update, :id => @category1.id, :category => {:name => 'CMU new name'}
        end

        should_assign_to :category
        should_redirect_to("category's show view") { category_url(assigns(:category)) }
        should_respond_with 302
        should_change("the number of categories", :by => 0) { Category.count }
        should 'shange the name of @category to "CMU new name"' do
          assert_equal @category1.reload.name, "CMU new name"
        end
          should_set_the_flash_to "Category was successfully updated."
      end
      
      context "on :delete to :destroy with  :id => @category1.id" do
        setup do
          delete :destroy, :id => @category1.id
        end
        
        should_change("the number of categories", :by => -1) { Category.count }
        should_redirect_to("categories index view") {categories_url}
        should_set_the_flash_to "Category was successfully deleted."
      end
    end
  end
end
