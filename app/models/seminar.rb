class Seminar < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :location
  
  has_and_belongs_to_many :speakers
  has_and_belongs_to_many :hosts
  
  accepts_nested_attributes_for :speakers, :allow_destroy => true
  accepts_nested_attributes_for :hosts, :allow_destroy => true
  
  validates_associated :hosts, :speakers
  validates_presence_of :title, :start_on, :end_on#, :location_id
    
  default_scope :order => "seminars.start_on ASC", :include => 'category'
  named_scope :of_day, lambda{|datetime| {:conditions => ["(seminars.end_on IS NULL AND DATE(seminars.start_on) = ?) OR (DATE(seminars.start_on) <= ? AND DATE(seminars.end_on) >= ?)", datetime.to_date, datetime.to_date, datetime.to_date]}}
  named_scope :of_month, lambda{|datetime| {:conditions => ["(DATE(seminars.start_on) >= ? AND DATE(seminars.start_on) <= ?) OR (DATE(seminars.end_on) >= ? AND DATE(seminars.end_on) <= ?)", datetime.beginning_of_month.to_date, datetime.end_of_month.to_date, datetime.beginning_of_month.to_date, datetime.end_of_month.to_date]}}
  named_scope :past, :conditions => ["(seminars.end_on IS NULL AND seminars.start_on < ?) OR (seminars.end_on < ?)", Time.current, Time.current]
  named_scope :now_or_future, :conditions => ["(seminars.end_on IS NOT NULL AND seminars.end_on > ?) OR (seminars.start_on >= ?)", Time.current, Time.current]
  named_scope :all_for_user, lambda{|user|
    if user.role.name == 'basic'
      {:conditions => ["seminars.user_id = ?", user.id]}
    end
  }
  named_scope :of_categories, lambda{|categories| {:conditions => ["seminars.category_id IN (?)", categories.map{|c| c.id}]}}
  
  before_validation :set_end_on, :set_times_if_all_day
  after_save :check_presence_of_host_and_speaker
  before_destroy :destroy_speakers_and_hosts

  attr_accessor :all_day
  
  # def start_humanized_date
  #   if start_on
  #     if start_on == Date.today - 1
  #       start_humanized_date = "Yesterday"
  #     elsif start_on == Date.today + 1
  #       start_humanized_date = "Tomorrow"
  #     elsif start_on == Date.today
  #       start_humanized_date = "Today"
  #     else
  #       start_humanized_date = start_on.to_s(:long)
  #     end
  #     start_humanized_date = start_humanized_date + ", " + start_on.to_s(:db_with_zone) unless start_on.blank?
  #     return start_humanized_date 
  #   else
  #     return nil
  #   end
  # end
  
  def human_date(datetime)
    if datetime.to_date == Date.today - 1
      human_date = "Yesterday"
    elsif datetime.to_date == Date.today + 1
      human_date = "Tomorrow"
    elsif datetime.to_date == Date.today
      human_date = "Today"
    else
      human_date = datetime.to_date.to_s(:dotted_day_month_year)
    end
  end
  
  def human_time(datetime)
    datetime.to_s(:time_only)
  end
  
  def schedule
    if end_on.blank?
      if human_time(start_on) == "00:00"
        schedule = human_date(start_on)
      else
        schedule = human_date(start_on) + ', ' + human_time(start_on)
      end
    else
      if start_on.to_date == end_on.to_date
        if human_time(start_on) == "00:00" and human_time(end_on) == "23:59"
          schedule = human_date(start_on)
        else
          schedule = human_date(start_on) + ', ' + human_time(start_on) + "-" + human_time(end_on)
        end
      else
        if human_time(start_on) == "00:00" and human_time(end_on) == "23:59"
          schedule =  human_date(start_on) + " - " + human_date(end_on)
        else
          schedule = "#{human_date(start_on)}, #{human_time(start_on)} - #{human_date(end_on)}, #{human_time(end_on)}"
        end
      end
    end
    return schedule
  end
  
  def days
    (start_on.to_date..end_on.to_date).to_a
  end
  
  def when_and_where
    when_and_where = []
    when_and_where << schedule unless schedule.blank?
    when_and_where << location.name_and_building unless location.blank?
    return when_and_where.join(" - ")
  end
  
  def time_and_title
    time_and_title = []
    time_and_title << start_on.to_s(:time_only) unless start_on.to_s(:time_only) == "00:00"
    time_and_title << title
    return time_and_title.join(" - ")
  end
  
  def time_and_category
    time_and_category = []
    time_and_category << start_on.to_s(:time_only) unless start_on.to_s(:time_only) == "00:00"
    if category
      time_and_category << (category.acronym.blank? ? category.name : category.acronym)
    else
      time_and_category << title[0..15]
    end
    return time_and_category.join(" ")
  end
  
  def time_location_and_category
    time_and_category = []
    time_and_category << start_on.to_s(:time_only) unless start_on.to_s(:time_only) == "00:00"
    time_and_category << location.name_and_building unless location.blank?
    if category
      time_and_category << category.acronym ? category.acronym : category.name
    else
      time_and_category << title[0..15]
    end
    return time_and_category.join(" - ")
  end

  def date_time_location_and_category
    time_and_category = []
    time_and_category << start_on.strftime("%d.%m.%Y %H:%M")
    time_and_category << location.name_and_building unless location.blank?
    if category
      time_and_category << category.acronym ? category.acronym : category.name
    else
      time_and_category << title[0..15]
    end
    return time_and_category.join(" - ")
  end

  def editable_or_destroyable_by_user?(auser)
    user == auser || auser.role.name == 'admin'
  end
  
  def color
    category.color || '005C42'
  end
  
  # protected
  # 
  # def set_times
  #   self.start_time = nil unless all_day == false
  # end
  
  private
  
  def set_end_on
    self.end_on = (self.start_on+1.hour) if self.end_on.blank? and !self.start_on.blank?
  end
  
  def set_times_if_all_day
    self.start_on = self.start_on.beginning_of_day if self.all_day == '1' 
    self.end_on = self.end_on.end_of_day if self.all_day == '1' 
  end
  
  def check_presence_of_host_and_speaker
    raise("Seminar should have at least 1 host.") if self.hosts.blank?
    raise("Seminar should have at least 1 speaker.") if self.speakers.blank?
  end
  
  def destroy_speakers_and_hosts
    Speaker.destroy(speakers)
    Host.destroy(hosts)
  end
end
