require "get_model_permissions"
class SeminarSerializer < ActiveModel::Serializer
  get_model_permissions_and :id, :title, :description, :speaker_name, :speaker_affiliation, :start_at, :end_at, :url, :all_day, :internal, :pubmed_ids
  embed :ids
  has_one :location
  has_one :user
  # has_many :hostings, include: true
  has_many :hosts, include: true
  has_many :categories, include: true
  # has_many :categorisations, include: true
end
