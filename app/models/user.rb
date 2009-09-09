require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  belongs_to :role
  has_many :seminars, :dependent => :destroy

  # validates_presence_of     :login
  # validates_length_of       :login,    :within => 3..40
  # validates_uniqueness_of   :login
  # validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  before_validation :set_role_id
  
  validates_presence_of     :name
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message
  validates_length_of       :name,     :within => 3..100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_presence_of :role_id
  # validates_inclusion_of :role_id, :in => [Role.find_by_name('basic').id, Role.find_by_name('admin').id]

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation, :role_id
  
  default_scope :order => "users.name ASC"
  named_scope :all_for_user, lambda{ |a_user| 
    if a_user.basic?
      {:conditions => ["users.id = ?", a_user.id]}
    elsif a_user.admin?
      {:conditions => nil}
    else
      return false
    end
  }
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  # def self.authenticate(login, password)
  #   return nil if login.blank? || password.blank?
  #   u = find_by_login(login.downcase) # need to get the salt
  #   u && u.authenticated?(password) ? u : nil
  # end
  
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_by_email(email.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # def login=(value)
  #   write_attribute :login, (value ? value.downcase : nil)
  # end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def basic?
    role.name=='basic'
  end
  
  def admin?
    role.name=='admin'
  end
  
  def forgot_password
    @forgotten_password = true
    self.make_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate mail notifications.
    self.update_attribute(:reset_code, nil)
    @reset_password = nil
  end

  # Used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end

  # Used in user_observer
  def recently_reset_password?
    @reset_password
  end

  protected
  
  def make_reset_code
    self.reset_code = self.class.make_token
  end
  
  def notify_user
    UserMailer.deliver_signup_notification(self)
  end
  
  def set_role_id
    self.role_id = Role.find_by_name('basic').id if (self.role_id.nil? or ![Role.find_by_name('basic').id, Role.find_by_name('admin').id].include?(self.role_id))  
  end


end
