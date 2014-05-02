require "get_model_permissions"
class UserSerializer < ActiveModel::Serializer

  USER_MODELS = [Building, Category, Categorisation, Document, Hosting, Host, Location, Seminar, User]

  has_many :seminars

  atts = [:id, :name, :email, :admin, :readable, :updatable, :destroyable, :created_at_timestamp]

  USER_MODELS.each do |mod|
    method_name = "can_create_#{mod.to_s}"
    atts << method_name.to_sym

    define_method method_name do
      return Ability.new(object).can? :create, mod
      # return Permissions.permission_for(object).allow_action?(mod, :create) == true
    end
  end

  get_model_permissions_and *atts
  embed :ids

  def created_at_timestamp
    object.created_at.to_i
  end
end
