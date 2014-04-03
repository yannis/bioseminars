class Hosting < ActiveRecord::Base
  attr_accessor :readable, :updatable, :destroyable
  belongs_to :host, inverse_of: :hostings
  belongs_to :seminar, inverse_of: :hostings

  validates_presence_of :host_id, on: :update
  validates_presence_of :seminar_id, on: :update
end
