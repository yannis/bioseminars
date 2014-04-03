class Category < ActiveRecord::Base
  has_many :categorisations, inverse_of: :category, dependent: :destroy
  has_many :seminars, through: :categorisations

  validates_presence_of :name, :acronym, :color
  validates_uniqueness_of :name, :acronym, :color
  validates :color, css_hex_color: true
end
