require 'bio'
class Seminar < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :location
  has_many :documents, :as => :model, :dependent  => :destroy
  has_many :pictures, :as => :model, :dependent  => :destroy
  has_and_belongs_to_many :speakers
  has_and_belongs_to_many :hosts
  
  accepts_nested_attributes_for :speakers, :allow_destroy => true
  accepts_nested_attributes_for :hosts, :allow_destroy => true
  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  
  validates_associated :hosts, :speakers, :documents, :pictures
  validates_presence_of :start_on, :end_on#, :title, :location_id
  validates_each :end_on do |model, attr, value|
    unless model.end_on.blank?
      if model.end_on < model.start_on
        model.errors.add(attr, ": The seminar end time cannot be anterior to seminar start time.")
      end
    end
  end
    
  default_scope :order => "seminars.start_on ASC", :include => ['category', 'hosts', 'speakers']
  
  named_scope :of_day, lambda{|datetime| {:conditions => ["(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", datetime.to_time.beginning_of_day.utc, datetime.to_time.end_of_day.utc, datetime.to_time.beginning_of_day.utc, datetime.to_time.end_of_day.utc, datetime.to_time.beginning_of_day.utc, datetime.to_time.end_of_day.utc]}}
  
  
  named_scope :of_month, lambda{|datetime| {:conditions => ["(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", datetime.to_time.beginning_of_month.utc, datetime.to_time.end_of_month.utc, datetime.to_time.beginning_of_month.utc, datetime.to_time.end_of_month.utc, datetime.to_time.beginning_of_month.utc, datetime.to_time.end_of_month.utc]}}
  
  named_scope :past, :conditions => ["(seminars.end_on IS NULL AND seminars.start_on < ?) OR (seminars.end_on < ?)", Time.current.utc, Time.current.utc]
  named_scope :now_or_future, :conditions => ["(seminars.end_on IS NOT NULL AND seminars.end_on > ?) OR (seminars.start_on >= ?)", Time.current.utc, Time.current.utc]
  named_scope :all_for_user, lambda{|user|
    if user.role.name == 'basic'
      {:conditions => ["seminars.user_id = ?", user.id]}
    else
      {}
    end
  }
  named_scope :of_categories, lambda{|categories| {:conditions => ["seminars.category_id IN (?)", categories.map{|c| c.id}]}}
  named_scope :internal, lambda{|internal|
    if internal == false
      {:conditions => ["seminars.internal = ?", internal]}
    end
  }
  named_scope :all_day_first, :order => "all_day DESC, seminars.start_on ASC"
  
  before_validation :set_end_on
  after_save :check_presence_of_host_and_speaker
  before_destroy :destroy_speakers_and_hosts
  
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
  
  def start_time
    all_day? ? nil : human_time(start_on)
  end
  
  def schedule
    if end_on.blank?
      if all_day?
        schedule = human_date(start_on)
      else
        schedule = human_date(start_on) + ', ' + human_time(start_on)
      end
    else
      if start_on.to_date == end_on.to_date
        if all_day?
          schedule = human_date(start_on)
        else
          schedule = human_date(start_on) + ', ' + human_time(start_on) + "-" + human_time(end_on)
        end
      else
        if all_day?
          schedule =  human_date(start_on) + " - " + human_date(end_on)
        else
          schedule = "#{human_date(start_on)}, #{human_time(start_on)} - #{human_date(end_on)}, #{human_time(end_on)}"
        end
      end
    end
    return schedule
  end
  
  def days
    (start_on.in_time_zone.to_date..end_on.in_time_zone.to_date).to_a
  end
  
  def when_and_where
    when_and_where = []
    when_and_where << schedule unless schedule.blank?
    when_and_where << location.name_and_building unless location.blank?
    return when_and_where.join(" - ")
  end
  
  def start_time_and_title
    time_and_title = []
    time_and_title << start_time unless start_time.nil?
    time_and_title << title
    return time_and_title.join(" - ")
  end
  
  def time_and_category
    time_and_category = []
    time_and_category << start_time unless start_time.nil?
    if category
      time_and_category << (category.acronym_or_name)
    else
      time_and_category << title[0..15]
    end
    time_and_category << "<span class='redstar'>*</span>" if internal?
    return time_and_category.join(" ")
  end
  
  def time_location_and_category
    time_and_category = []
    time_and_category << start_time unless start_time.nil?
    time_and_category << location.name_and_building unless location.blank?
    if category
      time_and_category << category.acronym_or_name
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
      time_and_category << category.acronym_or_name
    else
      time_and_category << title[0..15]
    end
    return time_and_category.join(" - ")
  end

  def editable_or_destroyable_by_user?(auser)
    user == auser || auser.role.name == 'admin'
  end
  
  def color
    category.color || '007E64'
  end
  
  def only_one_speaker?
    speakers.size == 1
  end
  
  def mini_seminar_title
    if title.blank?
      if speakers.size == 1 and !speakers.first.title.blank?
        mini_title = speakers.first.title
      else
        mini_title = ''
      end
    else
      mini_title = title
    end
    return mini_title
  end
  
  def publications
    publications = []
    unless pubmed_ids.nil?
      entries = Bio::PubMed.efetch(pubmed_ids.scan(/\d+/).map{|e| e.to_i})# searches PubMed and get entry
      for entry in entries
        publication = Bio::MEDLINE.new(entry)
        publications << publication unless publication.title.blank? and publication.authors.blank? and publication.journal.blank?
      end
    end
    return publications
  end
  
  protected
  
  def set_end_on
    unless self.start_on.blank?
      self.end_on = (self.start_on+1.hour) if self.end_on.blank?
      if self.all_day == true
        self.start_on = self.start_on.to_time.beginning_of_day
        self.end_on = self.end_on.to_time.end_of_day
      end
    end
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
