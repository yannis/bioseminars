require "get_model_permissions"
class CategorisationSerializer < ActiveModel::Serializer
  get_model_permissions_and :id, :category_id, :seminar_id
end
