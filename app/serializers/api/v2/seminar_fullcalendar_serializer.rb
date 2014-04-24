class Api::V2::SeminarFullcalendarSerializer < ActiveModel::Serializer

  self.root = false

  attributes :id, :full_title, :speaker, :title, :start, :end, :url, :color, :schedule, :location, :hosts
  # attributes :id, :title, :description, :speaker_name, :speaker_affiliation, :start_at, :end_at, :url, :all_day, :internal, :pubmed_ids, :location, :hosts, :documents
  # has_one :location, include: true
  # has_one :user
  # has_many :hostings
  # has_many :hosts
  # has_many :categories
  # has_many :categorisations

  def start
    object.start_at.to_s(:timezoned)
  end

  def end
    object.end_at.to_s(:timezoned)
  end

  def url
    "http://#{Rails.application.secrets.mailer_host}#{object.ember_path}"
  end

  def color
    object.main_color
  end

  def full_title
    object.title
  end

  def speaker
    object.speaker_name_and_affiliation
  end

  def title
    t = []
    t << object.start_at.to_s(:time_only) if object.start_at.present?
    t << object.categories.map(&:acronym).join(" | ")
    t.join(" – ")
  end

  def location
    object.location.name_and_building
  end
end
