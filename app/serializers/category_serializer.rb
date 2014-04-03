require "get_model_permissions"
class CategorySerializer < ActiveModel::Serializer
  get_model_permissions_and :id, :name, :description, :color, :acronym, :position
  embed :ids

  has_many :seminars
end
