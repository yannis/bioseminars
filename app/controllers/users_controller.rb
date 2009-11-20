class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:home, :forgot_password, :reset_password]
  before_filter :admin_required, :only => [:index, :new, :create, :destroy]
  before_filter :basic_or_admin_required, :only => [:show, :edit, :update]
  before_filter :set_variables, :only => [:index, :show, :new, :create, :edit, :update]

  # def home
  #   if logged_in?
  #     @user = current_user
  #     respond_to do |format|
  #       format.html { redirect_to(user_path(@user)) }
  #     end
  #   else
  #     respond_to do |format|
  #       format.html { redirect_to(login_path) }
  #     end
  #   end
  # end
  
  def index
    @users = User.all
  end

  def show
    @user = User.all_for_user(current_user).find(params[:id])
  rescue
    respond_to do |format|
      flash[:warning] = "User not found."
      format.html { redirect_to(root_path) }
    end
  end
  # render new.rhtml
  def new
    @user = User.new(:role_id  => Role.find_by_name('basic').id)
  end
  
  def edit
    @user = User.all_for_user(current_user).find(params[:id])
    respond_to do |format|
      format.html
      format.js {
        render 'layouts/edit.rjs'
      }
    end
  rescue
    respond_to do |format|
      flash[:warning] = "User not found."
      format.html { redirect_to(root_path) }
    end
  end
 
  def create
    # logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      # self.current_user = @user # !! now logged in
      flash[:notice] = "User created. We're sending her an email with her account details."
      respond_to do |format|
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
        format.js { render 'layouts/insert_in_table' }
      end
    else  
      flash[:warning] = "User not created."
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.js { render 'layouts/insert_in_table' }
      end
    end
  end
  
  def update
    @user = User.all_for_user(current_user).find(params[:id])
    params[:user].delete(:role_id) if current_user.basic?

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_back_or_default(user_path(@user)) }
        format.xml  { head :ok }
        format.js {
          render 'layouts/update'
        }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.js {
          render 'layouts/update'
        }
      end
    end
  end
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @user.can_be_destroyed? and @user.destroy
      flash[:notice] = 'User was successfully deleted.'
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
        format.js { render 'layouts/remove_from_table' }
      end
    else
      flash[:warning] = 'User cannot be destroyed.'
      respond_to do |format|
        format.html { redirect_to(user_url(@user)) }
        format.xml  { head :ok }
        format.js { render 'layouts/remove_from_table' }
      end
    end
  rescue
    respond_to do |format|
      flash[:warning] = 'User not deleted.'
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
      format.js { render 'layouts/remove_from_table' }
    end
  end
  
  def forgot_password
    return unless request.post?
    if params[:user] and params[:user][:email] and @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      flash[:notice] = "A password reset link has been sent to your email address: #{@user.email}"
      redirect_to login_path
    else
      flash[:warning] = "Could not find a user with that email address: #{params[:user][:email]}"
    end
  end
  
  # action to perform when the user resets the password
  def reset_password
    @user = User.find_by_reset_code(params[:reset_code])
    return if (@user and params[:user].nil?)
    if params[:user][:password] && params[:user][:password_confirmation] and params[:user][:password] == params[:user][:password_confirmation]
      self.current_user = @user # for the next two lines to work
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      @user.reset_password
      current_user.save ? flash[:notice] = "Password reset successfull." : flash[:warning] = "Unable to reset password."
      redirect_back_or_default('/')
    else
      flash[:warning] = "Password mismatch."
    end
  rescue
    flash[:warning] = 'Unable to match reset code.'
    redirect_to forgot_password_path
  end
  
  protected
  
  def set_variables
    @roles = Role.find(:all)
    @new_user = User.new(:role_id  => Role.find_by_name('basic').id)
  end
end
