require 'test_helper'

class SeminarsControllerTest < ActionController::TestCase
  should route(:get, '/seminars').to(:action => :index)
  should route(:post, '/seminars').to(:action => :create)
  should route(:get, '/seminars/1').to(:action => :show, :id => 1)
  should route(:put, '/seminars/1').to(:action => :update, :id => 1)
  should route(:delete, '/seminars/1').to(:action => :destroy, :id => 1)
  should route(:get, '/seminars/new').to(:action => :new)
  
  context "2 seminars in the database," do
    setup do
      @seminar_count = Seminar.count
      @speaker_cout = Speaker.count
      @host_count = Host.count
      @seminar1 = Factory :seminar, :start_on => 2.weeks.since, :user => users(:basic)
      @seminar2 = Factory :seminar, :start_on => 2.weeks.ago, :user => users(:admin)
    end                                                                               
    
    should "change Seminar.count :by => 2" do
      assert Seminar.count-@seminar_count == 2
    end
    should "change Host.count :by => 2" do
      assert Host.count-@host_count == 2
    end
    should "change Speaker.count :by => 2" do
      assert Speaker.count-@speaker_cout == 2
    end
    
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
    
        should assign_to :seminars
        should respond_with :success
        should render_template :index
    
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
          assert_equal assigns(:seminars), Seminar.sort_by_order('asc').all
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
          assert_equal assigns(:seminars), Seminar.now_or_future.all
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
          assert_equal assigns(:seminars), Seminar.past.all
        end
      end
      
      context "on :get to :index with format :rss" do
        setup do
          get :index, :format => 'rss', :scope => 'future'
        end
      
        should assign_to :seminars
        should respond_with :success
        should_not render_with_layout
        should render_template 'index'
        should respond_with_content_type(:rss)
      
        should "assigns to 1 seminars" do #future seminar
          assert_equal assigns(:seminars).size, 1
        end
      end
      
      context "on :get to :index with format :ics" do
        setup do
          get :index, :format => 'ics', :scope => 'future'
        end
          
        should assign_to :seminars
        should respond_with :success
        should_not render_with_layout
          
        should "assigns to 1 seminars" do #future seminar
          assert_equal assigns(:seminars).size, 1
        end
      end
        
      
      context "on :get to :calendar" do
        setup do
          get :calendar
        end
    
        should assign_to :date
        should assign_to :seminars
        should respond_with :success
        should render_template :calendar
      end
      
      context "on :get to :show with :id => @seminar1.id" do
        setup do
          get :show, :id => @seminar1.id
        end
    
        should assign_to :seminar
        should respond_with :success
        should render_template :show
    
        should "assign to @seminar" do
          assert_equal assigns(:seminar), @seminar1
        end
      end
    
      context "on :get to :new" do
        setup do
          get :new
        end
        
        should redirect_to("/") { root_path }
        should set_the_flash.to(/You are not authorized to access this page/)
      end
    end
    
    context "when logged_in as basic," do
      setup do
        sign_in users(:basic)
        @ability = Ability.new(users(:basic))
      end
      
      context "on :get to :index" do
        setup do
          get :index
        end
           
        should assign_to :seminars
        should respond_with :success
        should render_template :index
           
        should "assigns to 2 seminar" do
          assert_equal assigns(:seminars).size, 2
        end
      end
      
      context "on :get to :calendar" do
        setup do
          get :calendar
        end
      
        should assign_to :date
        should assign_to :seminars
        should respond_with :success
        should render_template :calendar
      end
      
       context "on :delete to :destroy with  :id => @seminar1.id" do #@seminar1 belongs to basic
         setup do
           @seminar_count = Seminar.count
           @speaker_cout = Speaker.count
           @host_count = Host.count
           delete :destroy, :id => @seminar1.id
         end
         
         should ":basic be able to destroy @seminar1" do
           assert @ability.can?(:destroy, @seminar1)
         end
         
         should "change Seminar.count :by => -1" do
           assert Seminar.count-@seminar_count == -1
         end
         should "change Host.count :by => -1" do
           assert Host.count-@host_count == -1
         end
         should "change Speaker.count :by => -1" do
           assert Speaker.count-@speaker_cout == -1
         end
         should redirect_to("seminars index view") {seminars_url}
         should set_the_flash.to "Seminar was successfully deleted."
       end
       
        context "on :post to :create with valid data" do #@seminar1 belongs to basic
          setup do
            @seminar_count = Seminar.count
            @speaker_cout = Speaker.count
            @host_count = Host.count
            post :create, :seminar => {:location_id => Factory(:location).id, :speakers_attributes => {"index_to_replace_with_js" => {:name => 'speaker one', :title => "seminar title one", :affiliation => "affiliation one"}}, :hostings_attributes => {"index_to_replace_with_js" => {:host_id => Factory(:host).id}}, :start_on => 2.weeks.since.to_date.to_s(:db), :category_id => Factory(:category).id}
          end

          should "change Seminar.count :by => 1" do
            assert Seminar.count-@seminar_count == 1
          end
          should "change Host.count :by => 1" do
            assert Host.count-@host_count == 1
          end
          should "change Speaker.count :by => 1" do
            assert Speaker.count-@speaker_cout == 1
          end
          should redirect_to("newly created seminar view") {seminar_url(Seminar.last.id)}
          should set_the_flash.to "Seminar was successfully created."
        end
       
       context "on :delete to :destroy with  :id => @seminar2.id" do #@seminar1 belongs to admin
         setup do
           @seminar_count = Seminar.count
           @speaker_cout = Speaker.count
           @host_count = Host.count
           delete :destroy, :id => @seminar2.id
         end
                 
         should ":basic not be able to destroy @seminar2" do
           assert !@ability.can?(:destroy, @seminar2)
         end
         should redirect_to("root path") { root_path }
         should "change Seminar.count :by => 0" do
           assert Seminar.count-@seminar_count == 0
         end
         should "change Host.count :by => 0" do
           assert Host.count-@host_count == 0
         end
         should "change Speaker.count :by => 0" do
           assert Speaker.count-@speaker_cout == 0
         end
         should set_the_flash.to(/You are not authorized to access this page/)
         
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
    
        should assign_to :seminars
        should respond_with :success
        should render_template :index
    
        should "assigns to 2 seminars" do
          assert_equal assigns(:seminars).size, 2
        end
      end
    
      context "on :get to :show with :id  => @seminar1.id" do
        setup do
          get :show, :id => @seminar1.id
        end
    
        should assign_to :seminar
        should respond_with :success
        should render_template :show
    
        should "assign to @seminar" do
          assert_equal assigns(:seminar), @seminar1
        end
      end
    
      context "on :get to :new" do
        setup do
          get :new
        end
    
        should assign_to :seminar
        should respond_with :success
        should render_template :new
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end
    
      context "on :get to :edit with :id => @seminar1.id" do
        setup do
          get :edit, :id => @seminar1.id
        end
    
        should assign_to :seminar
        should respond_with :success
        should render_template :edit
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end
    
      context "on :post to :create with valid params" do
        setup do          
          @seminar_count = Seminar.count
          @speaker_cout = Speaker.count
          @host_count = Host.count
          post :create, :seminar => {:title => 'a third nice seminar title', :start_on => Time.parse("#{11.days.since} 16:00:00"), :location => Factory(:location), :category => Factory(:category), :speakers_attributes => {0 => {:name => 'speaker name 3', :affiliation => 'speaker affiliation 3', :title => 'a nice title'}}, :hostings_attributes => {"index_to_replace_with_js" => {:host_id => Factory(:host, :name => 'host name 3').id}}}
        end
    
        should assign_to :seminar
        should redirect_to("seminar's show view") { seminar_url(assigns(:seminar)) }
        should respond_with 302
        should "change Seminar.count :by => 1" do
          assert Seminar.count-@seminar_count == 1
        end
        should "change Host.count :by => 1" do
          assert Host.count-@host_count == 1
        end
        should "change Speaker.count :by => 1" do
          assert Speaker.count-@speaker_cout == 1
        end
        should set_the_flash.to "Seminar was successfully created."
        should "have the name of the speaker capitalized" do
          assert_equal assigns(:seminar).speakers.first.name, 'Speaker Name 3'
        end
        should "have the name of the host capitalized" do
          assert_equal assigns(:seminar).hosts.first.name, 'Host Name 3'
        end
      end
    
      context "on :put to :update with valid params for :id => @seminar1.id" do
        setup do
          @seminar_count = Seminar.count
          put :update, :id => @seminar1.id, :seminar => {:title => 'modified seminar title'}
        end
    
        should assign_to :seminar
        should redirect_to("seminar's show view") { seminar_url(assigns(:seminar)) }
        should respond_with 302
        should "change Seminar.count :by => 0" do
          assert Seminar.count-@seminar_count == 0
        end
        should 'shange the name of @seminar to "modified seminar title"' do
          assert_equal @seminar1.reload.title, "modified seminar title"
        end
          should set_the_flash.to "Seminar was successfully updated."
      end
      
    
      context "on :put to :update with :id => @seminar1.id trying to remove hosts" do
        setup do
          put :update, :id => @seminar1.id, :seminar => {:hostings_attributes =>{"#{@seminar1.hostings.first.id}"=>{"id"=>"#{@seminar1.hostings.first.id}", "_destroy"=>"1", "host_id"=>"#{@seminar1.hostings.first.host.id}"}}}
        end
    
        should assign_to :seminar
        should render_template :edit
        should 'have 1 host' do
          assert_equal assigns(:seminar).hosts, [@seminar1.hostings.first.host]
        end
      end
      
      context "on :delete to :destroy with :id => @seminar1.id" do
        setup do
          @seminar_count = Seminar.count
          @speaker_cout = Speaker.count
          @host_count = Host.count
          delete :destroy, :id => @seminar1.id
        end
         
        should "change Seminar.count :by => -1" do
          assert Seminar.count-@seminar_count == -1
        end
        should "change Host.count :by => -1" do
          assert Host.count-@host_count == -1
        end
        should "change Speaker.count :by => -1" do
          assert Speaker.count-@speaker_cout == -1
        end
        should redirect_to("seminars index view") {seminars_url}
        should set_the_flash.to "Seminar was successfully deleted."
      end
    end
  end
end
