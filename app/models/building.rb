class Building < ActiveRecord::Base
  has_many :locations, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
