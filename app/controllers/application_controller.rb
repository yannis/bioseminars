class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user_from_token!
  # check_authorization
  before_filter :authorize, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  delegate :allow_action?, to: :current_permission
  helper_method :allow_param?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?
  layout false
  respond_to :json, :html

  # unless Rails.application.config.consider_all_requests_local
  #   rescue_from Exception,                            :with => :render_error
  #   rescue_from ActionController::RoutingError,       :with => :render_not_found
  #   rescue_from ActionController::UnknownController,  :with => :render_not_found
  #   rescue_from ActionController::UnknownAction,      :with => :render_not_found
  # end

  rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found

  rescue_from CanCan::AccessDenied do |exception|
    render json: {message: exception.message}, status: 403
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :admin
  end

private

  def authorize
    if params[:user_id] && params[:authentication_token] && params[:controller] == "users" && params[:action] == "index"
      respond_with User.where(id: params[:user_id], authentication_token: params[:authentication_token])
    end
  end

  def authenticate_user_from_token!
    Rails.logger.debug "authenticate_user_from_token! called: #{params}"
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

  def render_not_found(exception)
    # logger.error(exception)
    # notify_airbrake(exception)
    render json: {message: exception.message}, status: 404
    # render :template => "/errors/404", :status => 404
  end


  # def render_error(exception)
  #   # logger.error(exception)
  #   # notify_airbrake(exception)
  #   render json: {message: exception.message}, status: 500
  # end
end
