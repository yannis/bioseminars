module GetModelPermissions

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def get_model_permissions_and(*atrrs)
      include InstanceMethods
      attributes(*(atrrs+[:readable, :updatable, :destroyable]))
    end
  end

  module InstanceMethods
    def readable
      Permissions.permission_for(scope).allow_action?(object.class.to_s.downcase.pluralize.to_sym, :show, object) == true
    end

    def updatable
      Permissions.permission_for(scope).allow_action?(object.class.to_s.downcase.pluralize.to_sym, :update, object) == true
    end

    def destroyable
      Permissions.permission_for(scope).allow_action?(object.class.to_s.downcase.pluralize.to_sym, :destroy, object) == true
    end
  end
end

ActiveModel::Serializer.send(:include, GetModelPermissions) if ActiveModel
