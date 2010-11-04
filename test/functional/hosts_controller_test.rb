require 'test_helper'

class HostsControllerTest < ActionController::TestCase
  should route(:get, '/hosts').to(:action => :index)
  should route(:post, '/hosts').to(:action => :create)
  should route(:get, '/hosts/1').to(:action => :show, :id => 1)
  should route(:put, '/hosts/1').to(:action => :update, :id => "1")
  should route(:delete, '/hosts/1').to(:action => :destroy, :id => 1)
  should route(:get, '/hosts/new').to(:action => :new)
  
  context "2 hosts in the database," do
    setup do
      @host1 = Factory :host
      @host2 = Factory :host
    end
    
    context "when not logged in," do

      context "on :get to :index" do
        setup do
          get :index
        end

        should assign_to :hosts
        should respond_with :success
        should render_template :index
      end
      
      context "on :get to :show with :id  => @host1.id" do
        setup do
          get :show, :id => @host1.id
        end

        should assign_to :host
        should respond_with :success
        should render_template :show
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :get to :edit with :id => @host1.id" do
        setup do
          get :edit, :id => @host1.id
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :post to :create with valid params" do
        setup do
          post :create, :host => {:name => 'CMU', :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :put to :update with valid params for :id => @host1.id" do
        setup do
          put :update, :id => @host1.id, :host => {:name => 'CMU new name'}
        end

        should redirect_to("login form") { '/users/sign_in' }
      end

      context "on :delete to :destroy with  :id => @host1.id" do
        setup do
          delete :destroy, :id => @host1.id
        end

        should redirect_to("login form") { '/users/sign_in' }
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

        should assign_to :hosts
        should respond_with :success
        should render_template :index

        should "assigns to 2 hosts" do
          assert_equal assigns(:hosts).size, 2
        end

      end

      context "on :get to :show with :id  => @host1.id" do
        setup do
          get :show, :id => @host1.id
        end

        should assign_to :host
        should respond_with :success
        should render_template :show

        should "assign to @host" do
          assert_equal assigns(:host), @host1
        end
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should assign_to :host
        should respond_with :success
        should render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :get to :edit with :id => @host1.id" do
        setup do
          get :edit, :id => @host1.id
        end

        should assign_to :host
        should respond_with :success
        should render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :post to :create with valid params" do
        setup do
          @hosts_count = Host.count
          post :create, :host => {:name => 'anew host', :email => "anew@host.com"}
        end

        should assign_to :host
        should redirect_to("host page") { host_url(assigns(:host)) }
        should respond_with 302
        should "change Host.count by 1" do
          assert_equal Host.count-@hosts_count, 1
        end
        should set_the_flash.to("Host was successfully created")
      end

      context "on :put to :update with valid params for :id => @host1.id" do
        setup do
          @hosts_count = Host.count
          put :update, :id => @host1.id, :host => {:name => 'anew hostname'}
        end

        should assign_to :host
        should redirect_to("host's show view") { host_url(assigns(:host)) }
        should respond_with 302
        should "change Host.count by 0" do
          assert_equal Host.count-@hosts_count, 0
        end
        should 'change the name of @host to "anew hostname"' do
          assert_equal @host1.reload.name, "Anew Hostname"
        end
        should set_the_flash.to("Host was successfully updated")
      end
      
      context "on :delete to :destroy with  :id => @host1.id" do
        setup do
          @hosts_count = Host.count
          delete :destroy, :id => @host1.id
        end
        
        should "change Host.count by -1" do
          assert_equal Host.count-@hosts_count, -1
        end
        should redirect_to("hosts index view") {hosts_url}
        should set_the_flash.to("Host was successfully deleted")
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

        should assign_to :hosts
        should respond_with :success
        should render_template :index

        should "assigns to 2 hosts" do
          assert_equal assigns(:hosts).size, 2
        end

      end

      context "on :get to :show with :id  => @host1.id" do
        setup do
          get :show, :id => @host1.id
        end

        should assign_to :host
        should respond_with :success
        should render_template :show

        should "assign to @host" do
          assert_equal assigns(:host), @host1
        end
      end

      context "on :get to :new" do
        setup do
          get :new
        end

        should assign_to :host
        should respond_with :success
        should render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :get to :edit with :id => @host1.id" do
        setup do
          get :edit, :id => @host1.id
        end

        should assign_to :host
        should respond_with :success
        should render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      context "on :post to :create with valid params" do
        setup do
          @hosts_count = Host.count
          post :create, :host => {:name => 'anew host', :email => "anew@host.com"}
        end

        should assign_to :host
        should redirect_to("host page") { host_url(assigns(:host)) }
        should respond_with 302
        should "change Host.count by 1" do
          assert_equal Host.count-@hosts_count, 1
        end
        should set_the_flash.to("Host was successfully created")
      end

      context "on :put to :update with valid params for :id => @host1.id" do
        setup do
          @hosts_count = Host.count
          put :update, :id => @host1.id, :host => {:name => 'anew hostname'}
        end

        should assign_to :host
        should redirect_to("host's show view") { host_url(assigns(:host)) }
        should respond_with 302
        should "change Host.count by 0" do
          assert_equal Host.count-@hosts_count, 0
        end
        should 'change the name of @host to "anew hostname"' do
          assert_equal @host1.reload.name, "Anew Hostname"
        end
        should set_the_flash.to("Host was successfully updated")
      end
      
      context "on :delete to :destroy with  :id => @host1.id" do
        setup do
          @hosts_count = Host.count
          delete :destroy, :id => @host1.id
        end
        
        should "change Host.count by -1" do
          assert_equal Host.count-@hosts_count, -1
        end
        should redirect_to("hosts index view") {hosts_url}
        should set_the_flash.to("Host was successfully deleted")
      end
    end
  end
end