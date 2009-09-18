require 'test_helper'

class SeminarTest < ActiveSupport::TestCase
  fixtures :all  
  
  should_belong_to :user
  should_belong_to :category
  should_belong_to :location
  should_have_and_belong_to_many :speakers
  should_have_and_belong_to_many :hosts

  should_validate_presence_of :title, :start_on, :end_on
  
  should_have_named_scope("of_day('2009-01-01 12:00:00')", {:conditions=>["(seminars.end_on IS NULL AND DATE(seminars.start_on) = ?) OR (DATE(seminars.start_on) <= ? AND DATE(seminars.end_on) >= ?)", Date.parse('2009-01-01 12:00:00'), Date.parse('2009-01-01 12:00:00'), Date.parse('2009-01-01 12:00:00')]})
  should_have_named_scope("of_month(Date.parse('2009-01-01 12:00:00'))", {:conditions => ["(DATE(seminars.start_on) >= ? AND DATE(seminars.start_on) <= ?) OR (DATE(seminars.end_on) >= ? AND DATE(seminars.end_on) <= ?)", Date.parse('2009-01-01 12:00:00').beginning_of_month, Date.parse('2009-01-01 12:00:00').end_of_month, Date.parse('2009-01-01 12:00:00').beginning_of_month, Date.parse('2009-01-01 12:00:00').end_of_month]})
  # should_have_named_scope("past", {:conditions => ["(seminars.end_on IS NULL AND seminars.start_on < ?) OR (seminars.end_on < ?)", Time.current, Time.current]})
  should_have_named_scope("all_for_user(User.find_by_name('basic'))", {:conditions => ["seminars.user_id = ?", 1]})
  should_have_named_scope("all_for_user(User.find_by_name('admin'))")
  
  context "A seminar without hosts and speakers," do
    setup do
      @building = Building.create(:name => 'ScIII')
      @location = Location.create(:name => '4059', :building => @building)
      @category = Category.create(:name => 'Life Science Seminar Series', :acronym => 'LSSS', :color => 'F0A9BB' )
      @seminar = users(:basic).seminars.new(:title => 'a nice seminar title', :start_on => Time.parse("#{Date.current} 12:00:00"), :location => @location, :category => @category)
    end

    should "not be valid" do
      assert_raise RuntimeError, LoadError do 
        @seminar.save
      end
    end
    
    context "when hosts and speakers are added," do
      setup do
        @seminar.update_attributes(:speakers_attributes => {0 => {:name => 'speaker name', :affiliation => 'speaker affiliation'}}, :hosts_attributes => {0 => {:name => 'host name', :email => 'host email'}})
        @seminar.save
      end
      
      should "be valid" do
        assert @seminar.valid?, @seminar.errors.full_messages.to_sentence
      end
      
      should 'have color == F0A9BB' do
        assert_equal @seminar.color, 'F0A9BB'
      end
      
      should "be editable_or_destroyable_by_user?(users(:basic))" do
        assert @seminar.editable_or_destroyable_by_user?(users(:basic))
      end
      
      should "be editable_or_destroyable_by_user?(users(:admin))" do
        assert @seminar.editable_or_destroyable_by_user?(users(:admin))
      end
      
      should_change("the number of speakers", :by => 1) { Speaker.count }
      should_change("the number of hosts", :by => 1) { Host.count }
      
      should 'have a end_on == Time.parse("#{Date.current} 13:00:00")' do
        assert_equal @seminar.end_on, Time.parse("#{Date.current} 12:00:00")+1.hour
      end
      
      should 'have schedule == "Today, 12:00-13:00"' do
        assert_equal @seminar.schedule, "Today, 12:00-13:00"
      end
      
      should 'have when_and_where == "Today, 12:00-13:00 - 4059 (ScIII)"' do
        assert_equal @seminar.when_and_where, 'Today, 12:00-13:00 - 4059 (ScIII)'
      end
      
      should 'have time_and_title == "12:00 - a nice seminar title"' do
        assert_equal @seminar.time_and_title, '12:00 - a nice seminar title'
      end
      
      should 'have time_and_category == "12:00: Life Science Seminar Series"' do
        assert_equal @seminar.time_and_category, '12:00: Life Science Seminar Series'
      end
      
      context "if the seminar now belongs to users(:admin)," do
        setup do
          @seminar.update_attributes(:user => users(:admin))
        end

        should "be valid" do
          assert @seminar.valid?, @seminar.errors.full_messages.to_sentence
        end
        
        should "belongs to users(:admin)" do
          assert_equal @seminar.user, users(:admin)
        end

        should "be editable_or_destroyable_by_user?(users(:admin))" do
          assert @seminar.editable_or_destroyable_by_user?(users(:admin))
        end

        should "not be editable_or_destroyable_by_user?(users(:basic))" do
          assert !@seminar.editable_or_destroyable_by_user?(users(:basic))
        end
      end
      
      context "when start_on == yesterday 11:00 and end_on == today 13:00" do
        setup do
          @seminar.update_attributes(:start_on => "#{Date.current.yesterday} 11:00:00", :end_on => "#{Date.current} 13:00:00")
        end
        
        should 'have when_and_where == "Yesterday, 11:00 - Today, 13:00 - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, 'Yesterday, 11:00 - Today, 13:00 - 4059 (ScIII)'
        end
        
        should 'have schedule == "Yesterday, 11:00 - Today, 13:00"' do
          assert_equal @seminar.schedule, "Yesterday, 11:00 - Today, 13:00"
        end
      end
      
      context "when start_on == 2009-01-01 11:00 and end_on == 2009-01-05 13:00" do
        setup do
          @seminar.update_attributes(:start_on => Time.parse("2009-01-01 11:00:00"), :end_on => Time.parse("2009-01-05 13:00:00"))
        end
        
        should 'have when_and_where == "2009-01-01, 11:00 - 2009-01-05, 13:00 - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, '2009-01-01, 11:00 - 2009-01-05, 13:00 - 4059 (ScIII)'
        end
        
        should 'have time_and_category == "11:00: Life Science Seminar Series"' do
          assert_equal @seminar.time_and_category, '11:00: Life Science Seminar Series'
        end
        
        should 'have schedule == "2009-01-01, 11:00 - 2009-01-05, 13:00"' do
          assert_equal @seminar.schedule, "2009-01-01, 11:00 - 2009-01-05, 13:00"
        end
      end
      
      context "when start_on == 2009-01-01 00:00 and end_on == 2009-01-05 23:59" do
        setup do
          @seminar.update_attributes(:start_on => Time.parse("2009-01-01 00:00:00"), :end_on => Time.parse("2009-01-05 23:59:00"))
        end

        should 'have when_and_where == "2009-01-01 - 2009-01-05 - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, '2009-01-01 - 2009-01-05 - 4059 (ScIII)'
        end
        
        should 'have schedule == "2009-01-01 - 2009-01-05"' do
          assert_equal @seminar.schedule, "2009-01-01 - 2009-01-05"
        end
      end
    
      context "when updated to set time to all-day" do
        setup do
          @seminar.update_attributes(:all_day => '1')
        end
    
        should 'have start_on == start_on.beginning_of_day' do
          assert_equal @seminar.start_on, @seminar.start_on.beginning_of_day
        end
    
        should 'have end_on  == end_on.end_of_day' do
          assert_equal @seminar.end_on, @seminar.end_on.end_of_day
        end

        should 'have when_and_where == "Today - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, 'Today - 4059 (ScIII)'
        end

        should 'have time_and_category == "Life Science Seminar Series"' do
          assert_equal @seminar.time_and_category, 'Life Science Seminar Series'
        end
        
        should 'have schedule == "Today"' do
          assert_equal @seminar.schedule, "Today"
        end
      end
      
      context 'when @seminar is destroyed' do
        setup do
          @seminar.destroy
        end
        
        should_change("the number of speakers", :by => -1) { Speaker.count }
        should_change("the number of hosts", :by => -1) { Host.count }
      end
    end
  end
end