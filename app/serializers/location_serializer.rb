require "get_model_permissions"
class LocationSerializer < ActiveModel::Serializer
  get_model_permissions_and :id, :name
  has_one :building, embed: :id, include: true
  has_many :seminars, embed: :id
end
