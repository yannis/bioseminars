require "get_model_permissions"
class BuildingSerializer < ActiveModel::Serializer
  get_model_permissions_and :id, :name
  embed :ids

  has_many :locations
end
