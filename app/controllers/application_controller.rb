class ApplicationController < ActionController::Base
  protect_from_forgery
  # check_authorization :unless => :devise_controller?

  # before_filter :login_required, :except => [:back]
  before_filter :store_location_if_html, :only => ["index", "show"]

  # see http://www.perfectline.co.uk/blog/custom-dynamic-error-pages-in-ruby-on-rails
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  def back
    redirect_back_or_default('/')
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  protected

  # def admin_required
  #   unless user_signed_in? and current_user.admin?
  #     redirect_to new_user_session_path, :alert => "No credentials."
  #   end
  # end
  #
  # def basic_or_admin_required
  #   unless user_signed_in?
  #     redirect_to new_user_session_path, :alert => "No credentials."
  #   end
  # end

  protected
  def store_location_if_html
    respond_to do |format|
      format.html {store_location}
      format.js {return false}
      format.json {return false}
      format.xml {return false}
      format.rss {return false}
      # format.iframe {return false}
      format.ics {return false}
    end
  end

  def back
    redirect_back_or_default('/')
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # def after_sign_in_path_for(resource)
  #   session[:return_to] || root_path
  # end

  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def render_not_found(exception)
    logger.error(exception)
    notify_airbrake(exception)
    render :template => "/errors/404", :status => 404
  end

  def render_error(exception)
    logger.error(exception)
    notify_airbrake(exception)
    render :template => "/errors/500", :status => 500
  end
end
