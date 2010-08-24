require 'test_helper'

class SeminarsControllerTest < ActionController::TestCase
  fixtures :all
  
  def login_as(user)
    @current_user = current_user = users(user)
    @request.session[:user_id] = users(user).id
  end
  
  should_route :get, '/seminars', :action => :index
  should_route :post, '/seminars', :action => :create
  should_route :get, '/seminars/1', :action => :show, :id => 1
  should_route :put, '/seminars/1', :action => :update, :id => 1
  should_route :delete, '/seminars/1', :action => :destroy, :id => 1
  should_route :get, '/seminars/new', :action => :new
  
  context "2 seminars in the database," do
    setup do
      # @building = Building.create(:name => 'ScIII')
      # @location = Location.create(:name => '4059', :building => @building)
      # @category = Category.create(:name => 'LSS')
      # @host = Factory :host, :name => 'host name basic', :email => 'host-basic@email.com'
      # @speaker = Factory :speaker, :name => 'speaker name', :affiliation => 'speaker affiliation', :title => 'semi title'
      @seminar1 = Factory :seminar, :start_on => 2.weeks.since, :user => users(:basic)
      @seminar2 = Factory :seminar, :start_on => 2.weeks.ago, :user => users(:admin)
    end                                                                               
    
    should_change "Seminar.count", :by => 2
    should_change "Speaker.count", :by => 2
    should_change "Host.count", :by => 2
    
    should '@seminar1 be valid' do
      assert @seminar1.valid?
    end
    
    should '@seminar1.hosts.size = 1' do
      assert_equal @seminar1.reload.hosts.size, 1
    end
    
    should '@seminar1.speakers.size = 1' do
      assert_equal @seminar1.reload.speakers.size, 1
    end
    
    should '@seminar2 be valid' do
      assert @seminar2.valid?
    end

    context "when not logged_in," do
      
      context "on :get to :index" do
        setup do
          get :index
        end
    
        should_assign_to :seminars
        should_respond_with :success
        should_render_template :index
    
        should "assigns to 1 seminar" do
          assert_equal assigns(:seminars).size, 2
        end
      end
      
      context "on :get to :index with :scope => 'all'" do
        setup do
          get :index, :scope => 'all'
        end
    
        should "assigns to 2 seminars" do #A future seminar
          assert_equal assigns(:seminars).size, 2
        end
    
        should "find all seminars" do
          assert_equal assigns(:seminars), Seminar.sort_by_order('asc')
        end
      end
    
      context "on :get to :index with :scope => 'future'" do
        setup do
          get :index, :scope => 'future'
        end
    
        should "assigns to 1 seminars" do #A future seminar
          assert_equal assigns(:seminars).size, 1
        end
        
        should "find @seminar2" do
          assert_equal assigns(:seminars), Seminar.now_or_future
        end
      end
    
      context "on :get to :index with :scope => 'past'" do
        setup do
          get :index, :scope => 'past'
        end
    
        should "assigns to 1 seminars" do #A future seminar
          assert_equal assigns(:seminars).size, 1
        end
    
        should "find @seminar1" do
          assert_equal assigns(:seminars), Seminar.past
        end
      end
      
      context "on :get to :index with format :rss" do
        setup do
          get :index, :format => 'rss', :scope => 'future'
        end
      
        should_assign_to :seminars
        should_respond_with :success
        should_render_without_layout
        should_render_template 'index.rss'
      
        should "assigns to 1 seminars" do #future seminar
          assert_equal assigns(:seminars).size, 1
        end
      end
      
      context "on :get to :index with format :ics" do
        setup do
          get :index, :format => 'ics', :scope => 'future'
        end
          
        should_assign_to :seminars
        should_respond_with :success
        should_render_without_layout
          
        should "assigns to 1 seminars" do #future seminar
          assert_equal assigns(:seminars).size, 1
        end
      end
        
      
      context "on :get to :calendar" do
        setup do
          get :calendar
        end
    
        should_assign_to :date
        should_assign_to :seminars
        should_respond_with :success
        should_render_template :calendar
      end
      
      context "on :get to :show with :id => @seminar1.id" do
        setup do
          get :show, :id => @seminar1.id
        end
    
        should_assign_to :seminar
        should_respond_with :success
        should_render_template :show
    
        should "assign to @seminar" do
          assert_equal assigns(:seminar), @seminar1
        end
      end
    
      context "on :get to :new" do
        setup do
          get :new
        end
        should_redirect_to("login form") { login_url }
      end
    end
    
    context "when logged_in as basic," do
       setup do
         login_as(:basic)
       end
       
       context "on :get to :index" do
         setup do
           get :index
         end
            
         should_assign_to :seminars
         should_respond_with :success
         should_render_template :index
            
         should "assigns to 2 seminar" do
           assert_equal assigns(:seminars).size, 2
         end
       end
       
       context "on :delete to :destroy with  :id => @seminar1.id" do #@seminar1 belongs to basic
         setup do
           delete :destroy, :id => @seminar1.id
         end
         
         should_change "Seminar.count", :by => -1
         should_change "Speaker.count", :by => -1
         should_change "Host.count", :by => -1
         should_redirect_to("seminars index view") {seminars_url}
         should_set_the_flash_to "Seminar was successfully deleted."
       end
       
        context "on :post to :create with valid data" do #@seminar1 belongs to basic
          setup do
            post :create, :seminar => {:location_id => Factory.create(:location).id.to_s, :speakers_attributes => {"index_to_replace_with_js" => {:name => 'speaker one', :title => "seminar title one", :affiliation => "affiliation one"}}, :host_ids => [Factory.create(:host).id.to_s], :start_on => 2.weeks.since.to_date.to_s(:db), :category_id => Factory(:category).id.to_s}
          end

          should_change "Seminar.count", :by => +1
          should_change "Speaker.count", :by => 1
          should_change "Host.count", :by => 1
          should_redirect_to("newly created seminar view") {seminar_url(Seminar.last.id)}
          should_set_the_flash_to "Seminar was successfully created."
        end
       
       context "on :delete to :destroy with  :id => @seminar2.id" do #@seminar1 belongs to admin
         setup do
           delete :destroy, :id => @seminar2.id
         end
         
         should_redirect_to("seminars show view") { seminars_url }
         should_change "Seminar.count", :by => 0
         should_change "Speaker.count", :by => 0
         should_change "Host.count", :by => 0
         should_set_the_flash_to Regexp.new("Couldn't find Seminar with ID=")
         
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
    
        should_assign_to :seminars
        should_respond_with :success
        should_render_template :index
    
        should "assigns to 2 seminars" do
          assert_equal assigns(:seminars).size, 2
        end
      end
    
      context "on :get to :show with :id  => @seminar1.id" do
        setup do
          get :show, :id => @seminar1.id
        end
    
        should_assign_to :seminar
        should_respond_with :success
        should_render_template :show
    
        should "assign to @seminar" do
          assert_equal assigns(:seminar), @seminar1
        end
      end
    
      context "on :get to :new" do
        setup do
          get :new
        end
    
        should_assign_to :seminar
        should_respond_with :success
        should_render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end
    
      context "on :get to :edit with :id => @seminar1.id" do
        setup do
          get :edit, :id => @seminar1.id
        end
    
        should_assign_to :seminar
        should_respond_with :success
        should_render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end
    
      context "on :post to :create with valid params" do
        setup do
          post :create, :seminar => {:title => 'a third nice seminar title', :start_on => Time.parse("#{11.days.since} 16:00:00"), :location => Factory(:location), :category => Factory(:category), :speakers_attributes => {0 => {:name => 'speaker name 3', :affiliation => 'speaker affiliation 3', :title => 'a nice title'}}, :hosts_attributes => {0 => {:name => 'host name 3', :email => 'host email 3'}}}
        end
    
        should_assign_to :seminar
        should_redirect_to("seminar's show view") { seminar_url(assigns(:seminar)) }
        should_respond_with 302
        should_change "Seminar.count", :by => 1
        should_change "Speaker.count", :by => 1
        should_change "Host.count", :by => 1
        should_set_the_flash_to "Seminar was successfully created."
        should "have the name of the speaker capitalized" do
          assert_equal assigns(:seminar).speakers.first.name, 'Speaker Name 3'
        end
        should "have the name of the host capitalized" do
          assert_equal assigns(:seminar).hosts.first.name, 'Host Name 3'
        end
      end
    
      context "on :put to :update with valid params for :id => @seminar1.id" do
        setup do
          put :update, :id => @seminar1.id, :seminar => {:title => 'modified seminar title'}
        end
    
        should_assign_to :seminar
        should_redirect_to("seminar's show view") { seminar_url(assigns(:seminar)) }
        should_respond_with 302
        should_change "Seminar.count", :by => 0
        should 'shange the name of @seminar to "modified seminar title"' do
          assert_equal @seminar1.reload.title, "modified seminar title"
        end
          should_set_the_flash_to "Seminar was successfully updated."
      end
      
    
      context "on :put to :update with :id => @seminar1.id trying to remove hosts" do
        setup do
          put :update, :id => @seminar1.id, :seminar => {:host_ids => [""]}
        end
    
        should_assign_to :seminar
        should_render_template :edit
        should 'have 0 host' do
          assert_equal assigns(:seminar).hosts, []
        end
      end
      
      context "on :delete to :destroy with :id => @seminar1.id" do
        setup do
          delete :destroy, :id => @seminar1.id
        end
        
        should_change "Seminar.count", :by => -1
        should_change "Speaker.count", :by => -1
        should_change "Host.count", :by => -1
        should_redirect_to("seminars index view") {seminars_url}
        should_set_the_flash_to "Seminar was successfully deleted."
      end
    end
  end
end
