class Host < ActiveRecord::Base
  attr_accessor :readable, :updatable, :destroyable

  has_many :hostings, inverse_of: :host, dependent: :destroy
  has_many :seminars, through: :hostings

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email

end
