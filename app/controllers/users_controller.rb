class UsersController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :set_variables, :only => [:index, :show, :new, :create, :edit, :update]
  respond_to :html
  
  def index
    @users = User.all
  end

  def show
    @user = User.all_for_user(current_user).find(params[:id])
  rescue
    respond_to do |format|
      flash[:alert] = "User not found."
      format.html { redirect_to(root_path) }
    end
  end
  # render new.rhtml
  def new
    @user = User.new(:admin  => false)
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
      flash[:alert] = "User not found."
      format.html { redirect_to(root_path) }
    end
  end
  
  def create
    if @user.save
      flash[:notice] = 'User was successfully created'      
      respond_with @user do |format|
        format.js{
          @origin = params[:origin]
          render (@origin.nil? ? 'layouts/insert_in_table' : 'create'), :content_type => 'text/javascript', :layout => false
        }
      end
    else
      flash[:alert] = 'User not created'      
      respond_with @user do |format|
        format.js{
          @origin = params[:origin]
          render (@origin.nil? ? 'layouts/insert_in_table' : 'layouts/new'), :content_type => 'text/javascript', :layout => false
        }
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
          flash[:alert] = @user.errors.full_messages.to_sentence
          render 'layouts/update'
        }
      end
    end
  end


  # def destroy
  #   @user = User.find(params[:id])
  #   if @user.can_be_destroyed? and @user.destroy
  #     flash[:notice] = 'User was successfully deleted.'
  #     respond_to do |format|
  #       format.html { redirect_to(users_url) }
  #       format.xml  { head :ok }
  #       format.js { render 'layouts/remove_from_table' }
  #     end
  #   else
  #     flash[:alert] = 'User cannot be destroyed.'
  #     respond_to do |format|
  #       format.html { redirect_to(user_url(@user)) }
  #       format.xml  { head :ok }
  #       format.js { render 'layouts/remove_from_table' }
  #     end
  #   end
  # rescue
  #   respond_to do |format|
  #     flash[:alert] = 'User not deleted.'
  #     format.html { redirect_to(users_url) }
  #     format.xml  { head :ok }
  #     format.js { render 'layouts/remove_from_table' }
  #   end
  # end
  # 
  
  def destroy
    if @user.can_be_destroyed? and @user.destroy
      flash[:notice] = 'User was successfully deleted'
    else
      flash[:alert] = 'Unable to destroy user'
    end
    respond_with @user do |format|
      format.js { render 'layouts/remove_from_table', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  # def forgot_password
  #   return unless request.post?
  #   if params[:user] and params[:user][:email] and @user = User.find_by_email(params[:user][:email])
  #     @user.forgot_password
  #     @user.save
  #     flash[:notice] = "A password reset link has been sent to your email address: #{@user.email}"
  #     redirect_to login_path
  #   else
  #     flash[:alert] = "Could not find a user with that email address: #{params[:user][:email]}"
  #   end
  # end
  # 
  # # action to perform when the user resets the password
  # def reset_password
  #   @user = User.find_by_reset_code(params[:reset_code])
  #   return if (@user and params[:user].nil?)
  #   if params[:user][:password] && params[:user][:password_confirmation] and params[:user][:password] == params[:user][:password_confirmation]
  #     self.current_user = @user # for the next two lines to work
  #     current_user.password_confirmation = params[:user][:password_confirmation]
  #     current_user.password = params[:user][:password]
  #     @user.reset_password
  #     current_user.save ? flash[:notice] = "Password reset successfull." : flash[:alert] = "Unable to reset password."
  #     redirect_back_or_default('/')
  #   else
  #     flash[:alert] = "Password mismatch."
  #   end
  # rescue
  #   flash[:alert] = 'Unable to match reset code.'
  #   redirect_to forgot_password_path
  # end
  
  protected
  
  def set_variables
    @new_user = User.new(:admin  => false)
  end
end
