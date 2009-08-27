class Seminar < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :location
  
  has_and_belongs_to_many :speakers, :class_name => 'Person', :join_table => "seminars_speakers"
  has_and_belongs_to_many :hosts, :class_name => 'Person', :join_table => "hosts_seminars"
  
  accepts_nested_attributes_for :speakers, :allow_destroy => true
  accepts_nested_attributes_for :hosts, :allow_destroy => true
  
  validates_associated :hosts
  validates_presence_of :title, :start_on, :end_on#, :location_id
    
  default_scope :order => "seminars.start_on ASC"
  named_scope :of_day, lambda{|datetime| {:conditions => ["(seminars.end_on IS NULL AND DATE(seminars.start_on) = ?) OR (DATE(seminars.start_on) <= ? AND DATE(seminars.end_on) >= ?)", datetime.to_date, datetime.to_date, datetime.to_date]}}
  named_scope :of_month, lambda{|datetime| {:conditions => ["(DATE(seminars.start_on) >= ? AND DATE(seminars.start_on) <= ?) OR (DATE(seminars.end_on) >= ? AND DATE(seminars.end_on) <= ?)", datetime.beginning_of_month.to_date, datetime.end_of_month.to_date, datetime.beginning_of_month.to_date, datetime.end_of_month.to_date]}}
  named_scope :past, :conditions => ["(seminars.end_on IS NULL AND seminars.start_on < ?) OR (seminars.end_on < ?)", Time.current, Time.current]
      
  before_validation :set_end_on
  after_save :check_presence_of_host_and_speaker
  
  # before_validation :set_times

  # attr_writer :all_day
  # attr_reader :all_day
  # 
  # def before_save
  #   self.start_time = nil if self.all_day == '1'
  # end
  
  def start_humanized_date
    if start_date
      if start_date == Date.today - 1
        start_humanized_date = "Yesterday"
      elsif start_date == Date.today + 1
        start_humanized_date = "Tomorrow"
      elsif start_date == Date.today
        start_humanized_date = "Today"
      else
        start_humanized_date = start_date.to_s(:long)
      end
      start_humanized_date = start_humanized_date + ", " + start_time.to_s(:db_with_zone) unless start_time.blank?
      return start_humanized_date 
    else
      return nil
    end
  end
  
  def schedule
    schedule = []
    if start_on.to_date == Date.today - 1
      humanized_date = "Yesterday"
    elsif start_on.to_date == Date.today + 1
      humanized_date = "Tomorrow"
    elsif start_on.to_date == Date.today
      humanized_date = "Today"
    else
      humanized_date = start_on.to_date.to_s(:day_month_year)
    end
    if end_on.blank?
      if start_on.to_s(:time_only) == "00:00"
        schedule << humanized_date
      else
        schedule << humanized_date + ', ' + start_on.to_s(:time_only)
      end
    else
      if start_on.to_date == end_on.to_date
        schedule << humanized_date + ', ' + start_on.to_s(:time_only) + "-" + end_on.to_s(:time_only)
      else
        if start_on.to_s(:time_only) == "00:00" and end_on.to_s(:time_only) == "00:00"
          schedule << start_on.to_s(:day_month_year) + " - " + end_on.to_s(:day_month_year)
        else
          schedule << start_on.to_s(:day_month_year_hour_minute) + " - " + end_on.to_s(:day_month_year_hour_minute)
        end
      end
    end
    return schedule
  end
  
  def when_and_where
    when_and_where = []
    when_and_where << location.name_and_building unless location.blank?
    when_and_where += schedule unless schedule.blank?
    return when_and_where.join(" - ")
  end
  
  def time_and_title
    time_and_title = []
    time_and_title << start_on.to_s(:time_only) unless start_on.to_s(:time_only) == "00:00"
    time_and_title << title
    return time_and_title.join(" - ")
  end
  
  # protected
  # 
  # def set_times
  #   self.start_time = nil unless all_day == false
  # end
  
  private
  
  def set_end_on
    self.end_on = (self.start_on+1.hour) if self.end_on.blank?    
  end
  
  def check_presence_of_host_and_speaker
    raise("Seminar should have at least 1 host.") if self.hosts.blank?
    raise("Seminar should have at least 1 speaker.") if self.speakers.blank?
  end
end
