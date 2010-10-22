require 'test_helper'

class SeminarTest < ActiveSupport::TestCase
  # fixtures :all  
  
  should belong_to :user
  should belong_to :category
  should belong_to :location
  should have_many :pictures
  should have_many :documents
  should have_many :speakers
  should have_many :hostings
  should have_many(:hosts).through(:hostings)
  
  should validate_presence_of :start_on
  should validate_presence_of :end_on
  
  # should have_named_scope("of_day('#{Time.parse('2009-01-01 01:00:00')}')", {:conditions=>["(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", Time.parse('2009-01-01 01:00:00').utc.beginning_of_day, Time.parse('2009-01-01 01:00:00').utc.end_of_day, Time.parse('2009-01-01 01:00:00').utc.beginning_of_day, Time.parse('2009-01-01 01:00:00').utc.end_of_day, Time.parse('2009-01-01 01:00:00').utc.beginning_of_day, Time.parse('2009-01-01 01:00:00').utc.end_of_day]})
  # 
  # should have_named_scope("of_month(Date.parse('2009-01-01 12:00:00'))", {:conditions=>["(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", Time.parse('2009-01-01 12:00:00').beginning_of_month.utc-7.days, Time.parse('2009-01-01 12:00:00').end_of_month.utc+7.days, Time.parse('2009-01-01 12:00:00').beginning_of_month.utc-7.days, Time.parse('2009-01-01 12:00:00').end_of_month.utc+7.days, Time.parse('2009-01-01 12:00:00').beginning_of_month.utc-7.days, Time.parse('2009-01-01 12:00:00').end_of_month.utc+7.days]})
  # 
  # # should_have_named_scope("past", {:conditions => ["(seminars.end_on IS NULL AND seminars.start_on < ?) OR (seminars.end_on < ?)", Time.current, Time.current]})
  # should have_named_scope("all_for_user(User.find_by_name('basic'))", {:conditions => ["seminars.user_id = ?", 1]})
  # should have_named_scope("all_for_user(User.find_by_name('admin'))")
  
  context "A seminar" do
    setup do
      @seminar = Factory.build :seminar
    end

    should "be valid" do
      assert @seminar.valid?, @seminar.errors.full_messages.to_sentence
    end
  end
  
  context "A seminar without speaker" do
    setup do
      @seminar = Factory.build :seminar, :speakers => []
    end

    should "not be valid" do
      assert !@seminar.valid?, @seminar.errors.full_messages.to_sentence
    end
    
    should "have errors on speakers" do
      @seminar.valid?
      assert_match /Speakers : Seminar should have at least 1 speaker/, @seminar.errors.full_messages.to_sentence
    end
  end
  
  context "A seminar without hostings" do
    setup do
      @seminar = Factory.build :seminar, :hostings_attributes => {}
    end

    should "not be valid" do
      assert !@seminar.valid?, @seminar.errors.full_messages.to_sentence
    end
    
    should "have errors on hostings" do
      @seminar.valid?
      assert_match /Hosts : Seminar should have at least 1 host/, @seminar.errors.full_messages.to_sentence
    end
  end
  
  context "with twice the same host" do
    setup do
      @host = Factory :host
      @seminar = Factory :seminar, :hostings_attributes => {:one => {:host => @host}, :two => {:host => @host}}
    end
    
    should "not be valid" do
      assert !@seminar.valid?, @seminar.errors.full_messages.to_sentence
    end
    
    should "have errors on hostings" do
      @seminar.valid?
      # assert_match /Hostings is invalid/, @seminar.errors.full_messages.to_sentence
      assert_match /Hostings is invalid/, @seminar.hostings.map(&:errors).to_s
    end
    
    # should "have the host duplicate removed before validation" do
    #   assert_equal @seminar.reload.hosts, [@host]
    # end
  end
  #         
  #   context "when hosts and speakers are added," do
  #     setup do
  #       @seminar.speakers << Factory(:speaker, :name => 'speaker name', :affiliation => 'speaker affiliation', :title => 'first speaker title')
  #       @seminar.hosts << Factory(:host, :name => 'host name prout', :email => 'host@email.com')
  #       @seminar.hosts << Host.find('1')
  #       @seminar.hosts << Host.find('2')
  #       @seminar.save
  #     end
  #     
  #     should "be valid" do
  #       assert @seminar.valid?, @seminar.errors.full_messages.to_sentence
  #     end
  #     
  #     should 'have color == F0A9BB' do
  #       assert_equal @seminar.color, 'F0A9BB'
  #     end
  #     
  #     should "be editable_or_destroyable_by_user?(users(:basic))" do
  #       assert @seminar.editable_or_destroyable_by_user?(users(:basic))
  #     end
  #     
  #     should "be editable_or_destroyable_by_user?(users(:admin))" do
  #       assert @seminar.editable_or_destroyable_by_user?(users(:admin))
  #     end
  #     
  #     should "change Speaker.count by 1" do
  #       assert Speaker.count-@speaker_count ==1
  #     end
  #     
  #     should "change Host.count by 1" do
  #       assert Host.count-@host_count ==1
  #     end
  #     
  #     should "have 3 hosts" do
  #       assert_equal @seminar.hosts.size, 3
  #     end
  #     
  #     should "have 1 speaker" do
  #       assert_equal @seminar.speakers.size, 1
  #     end
  #     
  #     should 'have a end_on == Time.parse("#{Date.current} 13:00:00")' do
  #       assert_equal @seminar.end_on, Time.parse("#{Date.current} 12:00:00")+1.hour
  #     end
  #     
  #     should 'have schedule == "Today, 12:00-13:00"' do
  #       assert_equal @seminar.schedule, "Today, 12:00-13:00"
  #     end
  #     
  #     should 'have when_and_where == "Today, 12:00-13:00 - 4059 (ScIII)"' do
  #       assert_equal @seminar.when_and_where, 'Today, 12:00-13:00 - 4059 (ScIII)'
  #     end
  #     
  #     should 'have time_and_title == "12:00 - a nice seminar title"' do
  #       assert_equal @seminar.start_time_and_title, '12:00 - a nice seminar title'
  #     end
  #     
  #     should 'have time_and_category == "12:00: LSSS"' do
  #       assert_equal @seminar.time_and_category, '<strong>12:00</strong> LSSS'
  #     end
  #     
  #     context "if end_on < start_on," do
  #       setup do
  #         @seminar.update_attributes(:end_on => @seminar.start_on-2.days)
  #       end
  # 
  #       should "not be valid" do
  #         assert !@seminar.valid?, @seminar.errors.full_messages.to_sentence
  #         assert @seminar.errors[:end_on].any?
  #       end
  #     end
  #     
  #     
  #     context "if the seminar now belongs to users(:admin)," do
  #       setup do
  #         @seminar.update_attributes(:user => users(:admin))
  #       end
  # 
  #       should "be valid" do
  #         assert @seminar.valid?, @seminar.errors.full_messages.to_sentence
  #       end
  #       
  #       should "belongs to users(:admin)" do
  #         assert_equal @seminar.user, users(:admin)
  #       end
  # 
  #       should "be editable_or_destroyable_by_user?(users(:admin))" do
  #         assert @seminar.editable_or_destroyable_by_user?(users(:admin))
  #       end
  # 
  #       should "not be editable_or_destroyable_by_user?(users(:basic))" do
  #         assert !@seminar.editable_or_destroyable_by_user?(users(:basic))
  #       end
  #     end
  #     
  #     context "when start_on == yesterday 11:00 and end_on == today 13:00" do
  #       setup do
  #         @seminar.update_attributes(:start_on => "#{Date.current.yesterday} 11:00:00", :end_on => "#{Date.current} 13:00:00")
  #       end
  #       
  #       should 'have when_and_where == "Yesterday, 11:00 - Today, 13:00 - 4059 (ScIII)"' do
  #         assert_equal @seminar.when_and_where, 'Yesterday, 11:00 - Today, 13:00 - 4059 (ScIII)'
  #       end
  #       
  #       should 'have schedule == "Yesterday, 11:00 - Today, 13:00"' do
  #         assert_equal @seminar.schedule, "Yesterday, 11:00 - Today, 13:00"
  #       end
  #     end
  #     
  #     context "when start_on == 2009-01-01 11:00 and end_on == 2009-01-05 13:00" do
  #       setup do
  #         @seminar.update_attributes(:start_on => Time.parse("2009-01-01 11:00:00"), :end_on => Time.parse("2009-01-05 13:00:00"))
  #       end
  #       
  #       should 'have when_and_where == " 1 January 2009, 11:00 -  5 January 2009, 13:00 - 4059 (ScIII)"' do
  #         assert_equal @seminar.when_and_where, ' 1 January 2009, 11:00 -  5 January 2009, 13:00 - 4059 (ScIII)'
  #       end
  #       
  #       should 'have time_and_category == "<strong>11:00</strong> LSSS"' do
  #         assert_equal @seminar.time_and_category, '<strong>11:00</strong> LSSS'
  #       end
  #       
  #       should 'have schedule == "1 January 2009, 11:00 -  5 January 2009, 13:00"' do
  #         assert_equal @seminar.schedule, " 1 January 2009, 11:00 -  5 January 2009, 13:00"
  #       end
  #     end
  #     
  #     context "when :all_day => true" do
  #       setup do
  #         @seminar.update_attributes(:all_day => true)
  #       end
  # 
  #       should 'have when_and_where == "2009-01-01 - 2009-01-05 - 4059 (ScIII)"' do
  #         assert_equal @seminar.when_and_where, 'Today - 4059 (ScIII)'
  #       end
  #       
  #       should 'have schedule == "2009-01-01 - 2009-01-05"' do
  #         assert_equal @seminar.schedule, "Today"
  #       end
  #     end
  #     
  #     context "when :all_day => true and :end_on == 2.days.since" do
  #       setup do
  #         @seminar.update_attributes(:all_day => true, :end_on => 2.days.since)
  #       end
  # 
  #       should 'have when_and_where == "2009-01-01 - 2009-01-05 - 4059 (ScIII)"' do
  #         assert_equal @seminar.when_and_where, "Today - #{2.days.since.to_date.to_s(:dotted_day_month_year)} - 4059 (ScIII)"
  #       end
  #       
  #       should 'have schedule == "2009-01-01 - 2009-01-05"' do
  #         assert_equal @seminar.schedule, "Today - #{2.days.since.to_date.to_s(:dotted_day_month_year)}"
  #       end
  #     end
  #   
  #     context "when updated to set time to all-day" do
  #       setup do
  #         @seminar.update_attributes(:all_day => true)
  #       end
  # 
  #       should 'have when_and_where == "Today - 4059 (ScIII)"' do
  #         assert_equal @seminar.when_and_where, 'Today - 4059 (ScIII)'
  #       end
  # 
  #       should 'have time_and_category == "LSSS"' do
  #         assert_equal @seminar.time_and_category, 'LSSS'
  #       end
  #       
  #       should 'have schedule == "Today"' do
  #         assert_equal @seminar.schedule, "Today"
  #       end
  #     end
  #     
  #     should 'Speaker.all.size == 1' do
  #       assert_equal Speaker.all.size, 1
  #     end
  #     
  #     should 'Host.all.size == 3' do
  #       assert_equal Host.all.size, 3
  #     end
  #     
  #     context 'when @seminar is destroyed' do
  #       setup do
  #         @seminar.destroy
  #       end
  #     
  #       should 'Speaker.all.size == 0' do
  #         assert_equal Speaker.all.size, 0
  #       end
  #     
  #       should 'Host.all.size == 0' do
  #         assert_equal Host.all.size, 0
  #       end
  #     end
  #     
  #     context 'when @seminar is internal' do
  #       setup do
  #         @seminar.update_attributes(:internal => true)
  #       end
  #       should 'have time_and_category == <strong>12:00</strong> LSSS <span class="redstar">*</span>' do
  #         assert_equal @seminar.time_and_category, "<strong>12:00</strong> LSSS <span class='redstar'>*</span>"
  #       end
  #     end
  #     
  #     context 'with a pubmed_id' do
  #       setup do
  #         @seminar.update_attributes(:pubmed_ids => '19557678 19498168, 19266017')
  #       end
  #       
  #       should "have 3 publications" do
  #         assert @seminar.publications.size, 3
  #       end
  #       
  #       should "have the title of one of the publications == 'Epigenetic temporal control of mouse Hox genes in vivo.'" do
  #         assert @seminar.publications.map(&:title).include?('Epigenetic temporal control of mouse Hox genes in vivo.')
  #       end
  #     end
  #     
  #     context "when a pdf and a picture are uploaded," do
  #       setup do
  #         @picture_count = Picture.count
  #         @document_count = Document.count
  #         @seminar.documents.create(:data => File.new(Rails.root + "/test/fixtures/files/30_278_H.pdf"))
  #         @seminar.pictures.create(:data => File.new(Rails.root + "/test/fixtures/files/rails.png"))
  #       end
  #       
  #       should "have 1 document" do
  #         assert_equal @seminar.reload.documents.size, 1
  #       end
  #       
  #       should "change Document.count by 1" do
  #         assert Document.count-@document_count == 1
  #       end
  #       should "change Picture.count by 1" do
  #         assert Picture.count-@picture_count == 1
  #       end
  # 
  #       should "have a document" do
  #         assert_equal @seminar.documents.size, 1
  #       end
  # 
  #       should "have a picture" do
  #         assert_equal @seminar.pictures.size, 1
  #       end
  #       
  #       context "and the picture is deleted" do
  #         setup do
  #           @picture_count = Picture.count
  #           @seminar.update_attributes(:pictures_attributes => {"#{@seminar.pictures.first.id}" => {:_destroy => '1', :id => "#{@seminar.pictures.first.id}"}})
  #         end
  #       
  #         should "change Picture.count by -1" do
  #           assert Picture.count-@picture_count == -1
  #         end
  # 
  #         should "destroy the picture" do
  #           assert_equal @seminar.reload.pictures.size, 0
  #         end
  #       end
  #       
  #     end      
  #   end
  # end
end