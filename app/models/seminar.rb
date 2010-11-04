require 'bio'
require File.dirname(__FILE__)+'/host.rb' 
class Seminar < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :location
  has_many :documents, :as => :model, :dependent  => :destroy
  has_many :pictures, :as => :model, :dependent  => :destroy
  has_many :speakers, :dependent  => :destroy
  has_many :hostings, :dependent  => :destroy
  has_many :hosts, :through => :hostings
  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :speakers, :allow_destroy => true
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  accepts_nested_attributes_for :hostings, :allow_destroy => true
  
  cattr_reader :per_page
  @@per_page = 20
  
  validates_associated :speakers, :documents, :pictures
  validates_presence_of :start_on, :end_on, :category_id, :user_id#, :title, :location_id
  validates_each :end_on do |model, attr, value|
    unless model.end_on.blank?
      if model.end_on < model.start_on
        model.errors.add(attr, ": The seminar end time cannot be anterior to seminar start time.")
      end
    end
  end
  
  validate :presence_of_speakers, :presence_of_hostings, :validate_host_uniqueness
  
  # validate do |seminar|
  #   for hosting in seminar.hostings
  #     hosting.errors.add(:host_id, "Host already selected.") if !hosting.marked_for_destruction? && seminar.hostings.select{|h| h.host_id == hosting.host_id}.size > 1
  #   end
  #   seminar.errors.add("Hosts",": A host is only allowed once") if seminar.hostings.map(&:host_id).uniq != seminar.hostings.select{|h| !h.marked_for_destruction? }.map(&:host_id)
  # end
    
  scope :all_included, :include => ['category', 'hosts', 'speakers', 'location']
  
  scope :of_day, lambda{|datetime| where("(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", datetime.to_time.beginning_of_day.utc, datetime.to_time.end_of_day.utc, datetime.to_time.beginning_of_day.utc, datetime.to_time.end_of_day.utc, datetime.to_time.beginning_of_day.utc, datetime.to_time.end_of_day.utc)}
  
  scope :of_month, lambda{|datetime| where("(seminars.start_on >= ? AND seminars.start_on <= ?) OR (seminars.end_on >= ? AND seminars.end_on <= ?) OR (seminars.start_on < ? AND seminars.end_on > ?)", datetime.to_time.beginning_of_month.utc-7.days, datetime.to_time.end_of_month.utc+7.days, datetime.to_time.beginning_of_month.utc-7.days, datetime.to_time.end_of_month.utc+7.days, datetime.to_time.beginning_of_month.utc-7.days, datetime.to_time.end_of_month.utc+7.days)}
  
  scope :past, where("(seminars.end_on IS NULL AND seminars.start_on < ?) OR (seminars.end_on < ?)", Time.current.utc, Time.current.utc)
  
  scope :now_or_future, where("(seminars.end_on IS NOT NULL AND seminars.end_on > ?) OR (seminars.start_on >= ?)", Time.current.utc, Time.current.utc)
  
  scope :all_for_user, lambda{|user|
    if user.basic?
      where("seminars.user_id = ?", user.id)
    end
  }
  
  scope :of_categories, lambda{|*categories| where("seminars.category_id IN (?)", categories.map{|c| c.id})}
  scope :internal, lambda{|internal|  where("seminars.internal = ?", internal) }
  scope :all_day_first, order("all_day DESC, seminars.start_on ASC")
  scope :next, where("seminars.start_on >= ?", Time.current.utc).order("seminars.start_on ASC")
  scope :after_date, lambda{|date| where("DATE(seminars.start_on) >= DATE(?)", date)}
  scope :before_date, lambda{|date| where("DATE(seminars.start_on) <= DATE(?)", date)}
  scope :with_publication, where(:pubmed_ids => !nil)
  scope :sort_by_order, lambda{|order| 
    if order == 'asc'
      order("seminars.start_on ASC")
    elsif order == 'desc'
      order("seminars.start_on DESC")
    end
  }
  
  before_validation :set_end_on# , :validate_host_uniqueness
  after_destroy :destroy_unused_hosts
  
  # after_save :check_presence_of_host_and_speaker
  
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
  
  def self.validate_pubmed_ids(pubmed_ids)
    messages = []
    unless pubmed_ids.nil?
      Bio::NCBI.default_email = "your.email@address.ch"
      entries = Bio::PubMed.efetch(pubmed_ids.scan(/\d+/).map{|e| e.to_i})# searches PubMed and get entry
      for entry in entries
        begin
          publication = Bio::MEDLINE.new(entry)
          messages << publication.title
        rescue
          messages << 'invalid'
        end
      end
    end
    return messages
  end
  
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
    return when_and_where.join(" - ").html_safe
  end
  
  def start_time_and_title
    time_and_title = []
    time_and_title << start_time unless start_time.nil?
    time_and_title << title
    return time_and_title.join(" - ").html_safe
  end
  
  def time_and_category
    time_and_category = []
    time_and_category << "<strong>"+start_time+"</strong>" unless start_time.nil?
    if category
      time_and_category << (category.acronym_or_name)
    else
      time_and_category << title[0..15]
    end
    time_and_category << "<span class='redstar'>*</span>" if internal?
    return time_and_category.join(" ").html_safe
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
    return time_and_category.join(" - ").html_safe
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
    return time_and_category.join(" - ").html_safe
  end

  # def editable_or_destroyable_by_user?(auser)
  #   user == auser || auser.admin?
  # end
  
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
      Bio::NCBI.default_email = "your.email@address.ch"
      entries = Bio::PubMed.efetch(pubmed_ids.scan(/\d+/).map{|e| e.to_i})# searches PubMed and get entry
      for entry in entries
        publication = Bio::MEDLINE.new(entry)
        publications << publication unless publication.title.blank? and publication.authors.blank? and publication.journal.blank?
      end
    end
    return publications
  end
  
  def next_seminar
    Seminar.find(:first, :conditions => ["seminars.start_on > ?", self.start_on], :order => 'seminars.start_on ASC')
  end
  
  def previous_seminar
    Seminar.find(:first, :conditions => ["seminars.start_on < ?", self.start_on], :order => 'seminars.start_on DESC')
  end
  
  def open_box?
    if description.blank? and pictures.detect{|p| !p.new_record?}.blank? and documents.detect{|p| !p.new_record?}.blank? and publications.blank? and url.blank?
      return false
    else
      return true
    end
  end
  
  # def set_host_through_attributes
  #   unless hosts_attributes.blank?
  #     hosts_attributes.each do |key,value|
  #       unless value[:email].blank? and value[:name].blank?
  #         h = (Host.find_by_email(value[:email])
  #         h = Host.find_by_name(value[:name])) if h.nil?
  #         h = Host.new(value) if h.nil?
  #         self.hosts << h
  #       end
  #     end
  #   end
  # end
  
  def doc_attributes=(doc_attributes)
    documents_content_type = ['application/pdf', 'application/msword', 'text/plain', 'text/rtf']
    doc_attributes.each do |key,value|
      if value[:data].content_type.match(/image/)
        pictures.build(value)
      elsif documents_content_type.include?(value[:data].content_type)
        documents.build(value)
      end
    end
  end
  
  def parse_start
    start_on = DateTime.strptime(start_on, '%d.%m.%Y %H:%M').to_time
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
  
  private
  
  def presence_of_hostings
    self.errors.add("Hosts",": Seminar should have at least 1 host") if self.hostings.blank? or self.hostings.all?{|hosting| hosting.marked_for_destruction? }
  end
  
  def validate_host_uniqueness
    for hosting in self.hostings
      if !hosting.marked_for_destruction? && self.hostings.select{|h| !h.marked_for_destruction? && h.host_id == hosting.host_id}.size > 1
        self.errors.add(:hosts,": A host is only allowed once") if self.errors[:hosts].blank?
        hosting.errors.add(:host_id, "Host already selected.")
      end
    end
  end
  
  def presence_of_speakers
    self.errors.add("Speakers",": Seminar should have at least 1 speaker") if self.speakers.blank?
  end
  
  def destroy_unused_hosts
    # for host in Host.all.select{|h| h.hostings.empty? }
    #   Host.destroy(host.id)
    # end
    # 
    Host.destroy(Host.select(:id).select{|h| h.hostings.empty? })
  end
end
