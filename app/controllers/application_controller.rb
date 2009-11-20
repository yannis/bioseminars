# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :login_required
  before_filter :store_location_if_html, :only => ["index", "show"]

  #see http://www.perfectline.co.uk/blog/custom-dynamic-error-pages-in-ruby-on-rails
  unless ActionController::Base.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end

  protected


  
  def back
    redirect_back_or_default('/')
  end
  
  protected
    
  def admin_required
    unless current_user and current_user.role.to_s == "admin"
      flash[:warning] = "No credentials."
      access_denied
    end
  end
  
  def basic_or_admin_required
    unless current_user and (current_user.role.to_s == "basic" || current_user.role.to_s == 'admin')
      flash[:warning] = "No credentials."
      access_denied
    end
  end
  
  def store_location_if_html
    respond_to do |format|
      format.html {store_location}
      format.js {return false}
      format.xml {return false}
      format.rss {return false}
      format.iframe {return false}
      format.ics {return false}
    end
  end
  
  private
  
  def render_not_found(exception)
    log_error(exception)
    notify_hoptoad(exception)
    render :template => "/errors/404", :status => 404
  end

  def render_error(exception)
    log_error(exception)
    notify_hoptoad(exception)
    render :template => "/errors/500", :status => 500
  end
end
