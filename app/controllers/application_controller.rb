# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :login_required
  before_filter :store_location_if_html, :only => ["index", "show", 'edit', 'new']

  
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
end
