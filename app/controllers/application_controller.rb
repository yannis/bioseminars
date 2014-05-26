class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user_from_token!#, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # delegate :allow_action?, to: :current_permission
  # helper_method :allow_param?

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
    render json: {errors: exception.message}, status: 403
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :admin
  end

private

  def authenticate_user_from_token!
    authorisation_params = ActionController::HttpAuthentication::Token.token_and_options(request)
    if authorisation_params.present?
      authorisation_params_token = authorisation_params.first
      authorisation_params_options = authorisation_params.last

      user_email = authorisation_params_options.fetch(:user_email, nil)
      user       = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, authorisation_params_token)
        sign_in user, store: false
      end
    end
  end

  def render_not_found(exception)
    # logger.error(exception)
    # notify_airbrake(exception)
    render json: {errors: exception.message}, status: 404
    # render :template => "/errors/404", :status => 404
  end


  # def render_error(exception)
  #   # logger.error(exception)
  #   # notify_airbrake(exception)
  #   render json: {errors: exception.message}, status: 500
  # end
end
