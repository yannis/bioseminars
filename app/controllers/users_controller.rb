class UsersController < ApplicationController

  def index
    @users = @current_resource
    respond_with @users
  end

  def show
    @user = @current_resource
    respond_with @user
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def update
    @user = @current_resource
    if @user.update_attributes(params[:user])
      render json: nil, status: :ok
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @user = @current_resource
    @user.destroy
    render json: nil, status: :ok
  end

private

  def current_resource
    @current_resource ||= params[:id] ? User.find(params[:id]) : User.loadable_by(current_user)
  end
end
