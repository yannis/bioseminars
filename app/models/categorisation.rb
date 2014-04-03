class Categorisation < ActiveRecord::Base
  attr_accessor :readable, :updatable, :destroyable

  belongs_to :category, inverse_of: :categorisations
  belongs_to :seminar, inverse_of: :categorisations

  validates_presence_of :category_id, on: :update
  validates_presence_of :seminar_id, on: :update
end
