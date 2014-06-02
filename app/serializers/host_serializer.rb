require "get_model_permissions"
class HostSerializer < ActiveModel::Serializer
  get_model_permissions_and :id, :name, :email
  # has_many :seminars, embed: :id
end
