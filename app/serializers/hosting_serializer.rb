require "get_model_permissions"
class HostingSerializer < ActiveModel::Serializer
  get_model_permissions_and :id, :host_id, :seminar_id
end
