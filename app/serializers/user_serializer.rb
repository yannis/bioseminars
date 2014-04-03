require "get_model_permissions"
class UserSerializer < ActiveModel::Serializer

  USER_MODELS = [:buildings, :categories, :categorisations, :documents, :hostings, :hosts, :locations, :seminars, :users, :speakers]

  has_many :seminars

  atts = [:id, :name, :email, :admin, :readable, :updatable, :destroyable]

  USER_MODELS.each do |mod|
    method_name = "can_create_#{mod.to_s}"
    atts << method_name.to_sym
    define_method method_name do
      return Permissions.permission_for(object).allow_action?(mod, :create) == true
    end
  end

  get_model_permissions_and *atts
  embed :ids
end
