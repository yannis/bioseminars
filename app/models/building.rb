class Building < ActiveRecord::Base
  has_many :locations, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  before_destroy :check_locations, prepend: true

  private

    def check_locations
      if self.locations.any?
        errors[:building] << "cannot be destroy if it has locations"
        return false
      end
    end
end
