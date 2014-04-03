class User < ActiveRecord::Base
  attr_accessor :readable, :updatable, :destroyable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :seminars

  validates_presence_of :name
  validates_uniqueness_of :email
  # email presence and length is validated by Devise

  before_save :ensure_authentication_token

  def self.loadable_by(user)
    return none if user.nil?
    return all if user.admin?
    return where(id: user.id) if user.member?
  end

  def member?
    self.persisted? && !self.admin?
  end


  ### Permissions

  def readable?
    true
  end

  def readable_by?(user)
    readable? && (user.presence.try(:admin?) || user.id == self.id)
  end

  def updatable?
    true
  end

  def updatable_by?(user)
    updatable? && (user.presence.try(:admin?) || user.id == self.id)
  end

  def destroyable?
    seminars.empty?
  end

  def destroyable_by?(user)
    destroyable? && user.presence.try(:admin?)
  end


  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
