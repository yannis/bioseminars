# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  skip_before_filter :login_required
  skip_before_filter :store_location

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    #modified by YJ to wor with email 3.6.2009
    # user = User.authenticate(params[:login], params[:password])
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      #modified by YJ to wor with email 3.6.2009
      # @login       = params[:login]
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    #modified by YJ to wor with email 3.6.2009
    # flash[:warning] = "Couldn't log you in as '#{params[:login]}'"
    # logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
    flash[:warning] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
