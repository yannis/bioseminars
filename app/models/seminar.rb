class Seminar < ActiveRecord::Base
  attr_accessor :readable, :updatable, :destroyable, :alarm

  belongs_to :location
  belongs_to :user
  has_many :categorisations, inverse_of: :seminar, dependent: :destroy
  has_many :categories, through: :categorisations, counter_cache: true
  has_many :hostings, inverse_of: :seminar, dependent: :destroy
  has_many :hosts, through: :hostings
  has_many :documents, as: :documentable, dependent: :destroy

  validates_presence_of :title, :speaker_name, :speaker_affiliation, :start_at, :end_at, :location_id, :user_id
  validates_uniqueness_of :title, scope: :speaker_name
  validates_associated :hostings, on: :update
  validates_associated :categorisations, on: :update
  validate :presence_of_categorisations
  validate :presence_of_hostings

  before_validation :set_end_at

  accepts_nested_attributes_for :hostings, allow_destroy: true
  accepts_nested_attributes_for :categorisations, allow_destroy: true
  accepts_nested_attributes_for :documents, allow_destroy: true

  def self.active
    includes(:categories).where(categories: {archived_at: nil}).references(:categories)
  end

  def self.past
    where("(seminars.end_at IS NULL AND seminars.start_at < ?) OR (seminars.end_at < ?)", Time.current, Time.current)
  end

  def self.now_or_future
    where("(seminars.end_at IS NOT NULL AND seminars.end_at > ?) OR (seminars.start_at >= ?)", Time.current, Time.current)
  end

  def self.of_day(datetime)
    where("(seminars.start_at >= ? AND seminars.start_at <= ?) OR (seminars.end_at >= ? AND seminars.end_at <= ?) OR (seminars.start_at < ? AND seminars.end_at > ?)", datetime.to_time.beginning_of_day, datetime.to_time.end_of_day, datetime.to_time.beginning_of_day, datetime.to_time.end_of_day, datetime.to_time.beginning_of_day, datetime.to_time.end_of_day)
  end

  def self.after_date(date)
    where("DATE(seminars.start_at) >= DATE(?)", date)
  end

  def self.before_date(date)
    where("DATE(seminars.start_at) <= DATE(?)", date)
  end

  def self.of_categories(categories)
    includes(:categories).where("categories.id IN (?)", categories.map{|c| c.id}).references(:categories)
  end

  def self.internal(internal)
    where("seminars.internal = ?", internal)
  end

  def self.all_day_first
    order("all_day DESC, seminars.start_at ASC")
  end

  def self.next
    where("seminars.start_at >= ?", Time.current).order("seminars.start_at ASC")
  end

  def self.with_publication
    where(:pubmed_ids => !nil)
  end

  def self.sort_by_order(order)
    if order == 'asc'
      order("seminars.start_at ASC")
    elsif order == 'desc'
      order("seminars.start_at DESC")
    end
  end

  def speaker_name_and_affiliation
    speaker_name_and_affiliation = [speaker_name]
    speaker_name_and_affiliation << "(#{speaker_affiliation})" if speaker_affiliation
    speaker_name_and_affiliation.join(" ")
  end

  def categorisations=(categorisations_data)
    if categorisations_data.blank?
      self.categorisations.destroy_all
    else
      self.categorisations.each do |categorisation|
        categorisation.destroy unless categorisations_data.map{|cd| cd.fetch(:category_id)}.include?(categorisation.category_id.to_s)
      end
      categorisations_data.uniq.each do |categorisation_data|
        self.categorisations.find_or_initialize_by category_id: categorisation_data.fetch(:category_id)
      end
    end
  end

  def hostings=(hostings_data)
    if hostings_data.blank?
      self.hostings.destroy_all
    else
      self.hostings.each do |hosting|
        hosting.destroy unless hostings_data.map{|hd| hd.fetch(:id, nil)}.compact.include?(hosting.id.to_s)
      end
      hostings_data.uniq.each do |hosting_data|
        self.hostings.find_or_initialize_by host_id: hosting_data.fetch(:host_id)
      end
    end
  end

  def human_date(datetime)
    if datetime.to_date == Date.today - 1
      human_date = "Yesterday"
    elsif datetime.to_date == Date.today + 1
      human_date = "Tomorrow"
    elsif datetime.to_date == Date.today
      human_date = "Today"
    else
      human_date = datetime.to_date.to_s(:day_month_year)
    end
  end

  def human_time(datetime)
    datetime.to_s(:time_only)
  end

  def start_time
    all_day? ? nil : human_time(start_at)
  end

  def schedule
    if end_at.blank?
      if all_day?
        schedule = human_date(start_at)
      else
        schedule = human_date(start_at) + ', ' + human_time(start_at)
      end
    else
      if start_at.to_date == end_at.to_date
        if all_day?
          schedule = human_date(start_at)
        else
          schedule = human_date(start_at) + ', ' + human_time(start_at) + "-" + human_time(end_at)
        end
      else
        if all_day?
          schedule =  human_date(start_at) + " - " + human_date(end_at)
        else
          schedule = "#{human_date(start_at)}, #{human_time(start_at)} - #{human_date(end_at)}, #{human_time(end_at)}"
        end
      end
    end
    return schedule
  end

  def to_ics(ical)
    seminar = self

    event_start = seminar.start_at
    event_end = seminar.end_at

    # tzid = Rails.application.config.time_zone
    # tz = TZInfo::Timezone.get tzid
    # timezone = tz.ical_timezone event_start
    # ical.add_timezone timezone

    ical.event do |event|
      event.summary = "#{seminar.categories.map(&:acronym).compact.join(', ')} – #{seminar.title}"
      # event.dtstart = Icalendar::Value::DateTime.new event_start, 'tzid' => tzid
      event.dtstart = seminar.start_at.try(:localtime)
      # event.dtstart = seminar.start_at.to_ical
      # event.dtend   = Icalendar::Value::DateTime.new event_end, 'tzid' => tzid
      event.dtend = seminar.end_at.try(:localtime)
      # event.dtend = seminar.end_at.to_ical
      event.location = seminar.location.name_and_building unless seminar.location.blank?
      description = []
      description << seminar.speaker_name_and_affiliation
      description << "Hosted by "+seminar.hosts.map(&:name).join(', ')
      event.description = description.join(' | ')
      event.url = "http://#{Rails.application.secrets.mailer_host}#{seminar.ember_path}"
      if seminar.alarm.present? && seminar.alarm.to_i >= 0
        event.alarm do |a|
          a.trigger = "-PT#{seminar.alarm}M"
          a.description = "#{seminar.categories.map(&:acronym).compact.join(', ')} – #{seminar.title}"
          a.action = 'DISPLAY'
        end
      end
    end
  end

  def main_color
    categories.order(:position).first.color
  end

  def ember_path
    "/#/seminars/#{id}"
  end

  private
    def presence_of_categorisations
      errors.add(:category, 'must have at least one category') if self.categorisations.blank?
    end

    def presence_of_hostings
      errors.add(:host, 'must have at least one host') if self.hostings.blank?
    end

    def set_end_at
      self.end_at = self.start_at+1.hour if self.start_at.present? && self.end_at.blank?
    end
end
