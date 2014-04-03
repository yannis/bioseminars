class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user_from_token!
  before_filter :authorize, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  delegate :allow_action?, to: :current_permission
  helper_method :allow_param?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?
  layout false
  respond_to :json, :html

  # # unless Rails.application.config.consider_all_requests_local
  #   rescue_from Exception,                            with: :render_error
  #   rescue_from ActiveRecord::RecordNotFound,         with: :render_error
  #   # rescue_from ActionController::RoutingError,       with: :render_not_found
  #   # rescue_from ActionController::UnknownController,  with: :render_not_found
  #   # rescue_from ActionController::UnknownAction,      with: :render_not_found
  # # end


  # # def render_not_found(exception)
  # #   logger.error(exception)
  # #   notify_airbrake(exception)
  # #   render json: {errors: exception.message}, status: :unprocessable_entity && return
  # #   render(json: exception.message, status: :unprocessable_entity) && return
  # # end

  # def render_error(e)
  #   Rails.logger.debug "e: #{e}"
  #   # notify_airbrake(e)
  #   render json: {errors: e.message}, status: :unprocessable_entity && return
  # end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :admin
  end

private

  def current_permission
    @current_permission ||= Permissions.permission_for(current_user)
  end

  def current_resource
    nil
  end

  def authorize
    if params[:user_id] && params[:authentication_token] && params[:controller] == "users" && params[:action] == "index"
      respond_with User.where(id: params[:user_id], authentication_token: params[:authentication_token])
    else
      if current_permission.allow_action?(params[:controller], params[:action], current_resource)
        current_permission.permit_params! params
      else
        render json: {success: false, message: "You are not authorized to access this page"}, status: :unauthorized
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    render(json: (e ? e.message : 'Unable to find object(s)'), status: :unprocessable_entity) && return
  end

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

end
