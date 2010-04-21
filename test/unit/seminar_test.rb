require 'test_helper'

class SeminarTest < ActiveSupport::TestCase
  fixtures :all  
  
  should_belong_to :user
  should_belong_to :category
  should_belong_to :location
  should_have_many :pictures
  should_have_many :documents
  should_have_many :speakers
  should_have_and_belong_to_many :hosts

  should_validate_presence_of :start_on, :end_on
  
  should_have_named_scope("of_day('#{Time.parse('2009-01-01 01:00:00')}')", {:conditions=>["(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", Time.parse('2009-01-01 01:00:00').utc.beginning_of_day, Time.parse('2009-01-01 01:00:00').utc.end_of_day, Time.parse('2009-01-01 01:00:00').utc.beginning_of_day, Time.parse('2009-01-01 01:00:00').utc.end_of_day, Time.parse('2009-01-01 01:00:00').utc.beginning_of_day, Time.parse('2009-01-01 01:00:00').utc.end_of_day]})
  
  should_have_named_scope("of_month(Date.parse('2009-01-01 12:00:00'))", {:conditions=>["(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", Time.parse('2009-01-01 12:00:00').beginning_of_month.utc-7.days, Time.parse('2009-01-01 12:00:00').end_of_month.utc+7.days, Time.parse('2009-01-01 12:00:00').beginning_of_month.utc-7.days, Time.parse('2009-01-01 12:00:00').end_of_month.utc+7.days, Time.parse('2009-01-01 12:00:00').beginning_of_month.utc-7.days, Time.parse('2009-01-01 12:00:00').end_of_month.utc+7.days]})
  
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
    
    should "have no speaker" do
      assert @seminar.speakers.blank?
    end

    should "not be valid" do
      assert_raise RuntimeError, LoadError do 
        @seminar.save
      end
    end
        
    context "when hosts and speakers are added," do
      setup do
        @seminar.speakers << Factory(:speaker, :name => 'speaker name', :affiliation => 'speaker affiliation', :title => 'first speaker title')
        @seminar.hosts << Factory(:host, :name => 'host name prout', :email => 'host@email.com')
        @seminar.hosts << Host.find('1')
        @seminar.hosts << Host.find('2')
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
      
      should_change "Speaker.count", :by => 1
      should_change "Host.count", :by => 1
      
      should "have 3 hosts" do
        assert_equal @seminar.hosts.size, 3
      end
      
      should "have 1 speaker" do
        assert_equal @seminar.speakers.size, 1
      end
      
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
        assert_equal @seminar.start_time_and_title, '12:00 - a nice seminar title'
      end
      
      should 'have time_and_category == "12:00: LSSS"' do
        assert_equal @seminar.time_and_category, '<strong>12:00</strong> LSSS'
      end
      
      context "if end_on < start_on," do
        setup do
          @seminar.update_attributes(:end_on => @seminar.start_on-2.days)
        end

        should "not be valid" do
          assert !@seminar.valid?, @seminar.errors.full_messages.to_sentence
          assert @seminar.errors.invalid?(:end_on)
        end
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
        
        should 'have when_and_where == " 1 January 2009, 11:00 -  5 January 2009, 13:00 - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, ' 1 January 2009, 11:00 -  5 January 2009, 13:00 - 4059 (ScIII)'
        end
        
        should 'have time_and_category == "<strong>11:00</strong> LSSS"' do
          assert_equal @seminar.time_and_category, '<strong>11:00</strong> LSSS'
        end
        
        should 'have schedule == "1 January 2009, 11:00 -  5 January 2009, 13:00"' do
          assert_equal @seminar.schedule, " 1 January 2009, 11:00 -  5 January 2009, 13:00"
        end
      end
      
      context "when :all_day => true" do
        setup do
          @seminar.update_attributes(:all_day => true)
        end

        should 'have when_and_where == "2009-01-01 - 2009-01-05 - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, 'Today - 4059 (ScIII)'
        end
        
        should 'have schedule == "2009-01-01 - 2009-01-05"' do
          assert_equal @seminar.schedule, "Today"
        end
      end
      
      context "when :all_day => true and :end_on == 2.days.since" do
        setup do
          @seminar.update_attributes(:all_day => true, :end_on => 2.days.since)
        end

        should 'have when_and_where == "2009-01-01 - 2009-01-05 - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, "Today - #{2.days.since.to_date.to_s(:dotted_day_month_year)} - 4059 (ScIII)"
        end
        
        should 'have schedule == "2009-01-01 - 2009-01-05"' do
          assert_equal @seminar.schedule, "Today - #{2.days.since.to_date.to_s(:dotted_day_month_year)}"
        end
      end
    
      context "when updated to set time to all-day" do
        setup do
          @seminar.update_attributes(:all_day => true)
        end

        should 'have when_and_where == "Today - 4059 (ScIII)"' do
          assert_equal @seminar.when_and_where, 'Today - 4059 (ScIII)'
        end

        should 'have time_and_category == "LSSS"' do
          assert_equal @seminar.time_and_category, 'LSSS'
        end
        
        should 'have schedule == "Today"' do
          assert_equal @seminar.schedule, "Today"
        end
      end
      
      should 'Speaker.all.size == 1' do
        assert_equal Speaker.all.size, 1
      end
      
      should 'Host.all.size == 3' do
        assert_equal Host.all.size, 3
      end
      
      context 'when @seminar is destroyed' do
        setup do
          @seminar.destroy
        end
      
        should 'Speaker.all.size == 0' do
          assert_equal Speaker.all.size, 0
        end
      
        should 'Host.all.size == 0' do
          assert_equal Host.all.size, 0
        end
      end
      
      context 'when @seminar is internal' do
        setup do
          @seminar.update_attributes(:internal => true)
        end
        should 'have time_and_category == <strong>12:00</strong> LSSS <span class="redstar">*</span>' do
          assert_equal @seminar.time_and_category, "<strong>12:00</strong> LSSS <span class='redstar'>*</span>"
        end
      end
      
      context 'with a pubmed_id' do
        setup do
          @seminar.update_attributes(:pubmed_ids => '19557678 19498168, 19266017')
        end
        
        should "have 3 publications" do
          assert @seminar.publications.size, 3
        end
        
        should "have the title of one of the publications == 'Epigenetic temporal control of mouse Hox genes in vivo.'" do
          assert @seminar.publications.map(&:title).include?('Epigenetic temporal control of mouse Hox genes in vivo.')
        end
      end
      
      context "when a pdf and a picture are uploaded," do
        setup do
          @seminar.update_attributes(:doc_attributes => {'index_to_replace_with_js' => {:data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/fixtures/files/30_278_H.pdf", 'application/pdf')}, '54545465' => {:data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/fixtures/files/rails.png", 'image/png')}})
        end
        
        should_change "Document.count", :by => 1
        should_change "Picture.count", :by => 1

        should "have a document" do
          assert_equal @seminar.documents.size, 1
        end

        should "have a picture" do
          assert_equal @seminar.pictures.size, 1
        end
        
        context "and the picture is deleted" do
          setup do
            @seminar.update_attributes(:pictures_attributes => {"#{@seminar.pictures.first.id}" => {:_delete => '1', :id => "#{@seminar.pictures.first.id}"}})
          end
          
          should_change "Picture.count", :by => -1

          should "destroy the picture" do
            assert_equal @seminar.reload.pictures.size, 0
          end
        end
        
      end      
    end
  end
end