require 'test_helper'

class SeminarTest < ActiveSupport::TestCase
  fixtures :all
  
  should_belong_to :user
  should_belong_to :category
  should_belong_to :location
  should_have_and_belong_to_many :speakers
  should_have_and_belong_to_many :hosts

  should_validate_presence_of :title, :start_on, :end_on
  
  should_have_named_scope "of_day('2009-01-01 12:00:00')", {:conditions=>["(seminars.end_on IS NULL AND DATE(seminars.start_on) = ?) OR (DATE(seminars.start_on) <= ? AND DATE(seminars.end_on) >= ?)", Date.parse('2009-01-01 12:00:00'), Date.parse('2009-01-01 12:00:00'), Date.parse('2009-01-01 12:00:00')]}
  should_have_named_scope "of_month(#{Time.parse('2009-01-01 12:00:00')})", {:conditions => ["(DATE(seminars.start_on) >= ? AND DATE(seminars.start_on) <= ?) OR (DATE(seminars.end_on) >= ? AND DATE(seminars.end_on) <= ?)", Date.parse('2009-01-01 12:00:00'), Date.parse('2009-01-01 12:00:00'), Date.parse('2009-01-01 12:00:00'), Date.parse('2009-01-01 12:00:00')]}
  
end


# belongs_to :user
# belongs_to :category
# belongs_to :location
# 
# has_and_belongs_to_many :speakers
# has_and_belongs_to_many :hosts
# 
# accepts_nested_attributes_for :speakers, :allow_destroy => true
# accepts_nested_attributes_for :hosts, :allow_destroy => true
# 
# validates_associated :hosts, :speakers
# validates_presence_of :title, :start_on, :end_on#, :location_id
#   
# default_scope :order => "seminars.start_on ASC"
# named_scope :of_day, lambda{|datetime| {:conditions => ["(seminars.end_on IS NULL AND DATE(seminars.start_on) = ?) OR (DATE(seminars.start_on) <= ? AND DATE(seminars.end_on) >= ?)", datetime.to_date, datetime.to_date, datetime.to_date]}}
# named_scope :of_month, lambda{|datetime| {:conditions => ["(DATE(seminars.start_on) >= ? AND DATE(seminars.start_on) <= ?) OR (DATE(seminars.end_on) >= ? AND DATE(seminars.end_on) <= ?)", datetime.beginning_of_month.to_date, datetime.end_of_month.to_date, datetime.beginning_of_month.to_date, datetime.end_of_month.to_date]}}
# named_scope :past, :conditions => ["(seminars.end_on IS NULL AND seminars.start_on < ?) OR (seminars.end_on < ?)", Time.current, Time.current]
# named_scope :all_for_user, lambda{|user|
#   if user.role.name == 'basic'
#     {:conditions => ["seminars.user_id = ?", user.id]}
#   end
# }