module Permissions
  class BasePermission

    def allow_action?(controller, action, resource = nil)
      allowed = @allow_all_actions || @allowed_actions[[controller.to_s, action.to_s]]
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    def allow_all_actions
      @allow_all_actions = true
    end

    def allow_action(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).flatten.each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end

    def allow_param(resources, attributes)
      @allowed_params ||= {}
      Array(resources).flatten.each do |resource|
        @allowed_params[resource] ||= []
        @allowed_params[resource] += Array(attributes)
      end
    end

    def allow_all_params
      @allow_all_params = true
    end

    def allow_param?(resource, attribute)
      if @allow_all_params
        true
      elsif @allowed_params && @allowed_params[resource]
        @allowed_params[resource].include? attribute
      end
    end

    def permit_params!(params)
      if @allow_all_params
        params.permit!
      elsif @allowed_params
        @allowed_params.each do |resource, attributes|
          if params[resource].respond_to? :permit
            params[resource] = params[resource].permit(*attributes)
          end
        end
      end
    end
  end
end
