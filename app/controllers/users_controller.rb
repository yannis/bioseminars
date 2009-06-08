class UsersController < ApplicationController
  
  before_filter :set_variables, :only => [:new, :create, :edit, :update]

  def home
    if logged_in?
      @user = current_user
      respond_to do |format|
        format.html { redirect_to (user_path(@user)) }
      end
    else
      respond_to do |format|
        format.html { redirect_to (login_path) }
      end
    end
  end
  
  def index
    @users = User.paginate :all, :page => params[:page]
  end

  def show
    @user = User.find(params[:id])
  end
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_back_or_default(user_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  protected
  
  def set_variables
    @roles = Role.find(:all)
    @laboratories = Laboratory.find(:all)
  end
end
