class Seminar < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :location
  has_and_belongs_to_many :speakers, :class_name => 'Person', :join_table => "seminars_speakers"
  has_and_belongs_to_many :hosts, :class_name => 'Person', :join_table => "hosts_seminars"
  
  validates_presence_of :title, :start_on#, :location_id
  
  accepts_nested_attributes_for :speakers, :allow_destroy => true
  accepts_nested_attributes_for :hosts, :allow_destroy => true
  
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
      humanized_date = start_on.to_date.to_s("%e %B %Y")
    end
    if end_on.blank?
      if start_on.to_s(:time_only) == "00:00"
        schedule << humanized_date
      else
        schedule << humanized_date + ', ' + start_on.to_s(:time_only)
      end
    else
      if start_on.to_date == end_on.to_date
        schedule << humanized_date + start_on.to_s(", %H:%M") + " - " + end_on.to_s("%H:%M")
      else
        if start_on.to_s(:time_only) == "00:00" and end_on.to_s(:time_only) == "00:00"
          schedule << start_on.to_date.to_s("%e %B %Y") + " - " + end_on.to_date.to_s("%e %B %Y")
        else
          schedule << start_on.to_s("%e %B %Y, %H:%M") + " - " + end_on.to_s("%e %B %Y, %H:%M")
        end
      end
    end
    return schedule
  end
  
  def when_and_where
    when_and_where = []
    when_and_where << location unless location.blank?
    when_and_where += schedule unless schedule.blank?
    return when_and_where.join(" - ")
  end
  
  # protected
  # 
  # def set_times
  #   self.start_time = nil unless all_day == false
  # end
end
