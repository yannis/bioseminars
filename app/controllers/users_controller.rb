class UsersController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def index
    respond_with @users
  end

  def show
    respond_with @user
  end

  def create
    if @user.save
      render json: @user, status: :created
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @user.update_attributes(sanitizer)
      render json: nil, status: :ok
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: nil, status: :ok
  end

  private

    def sanitizer
      if current_user.admin?
        params.require(:user).permit!
      elsif current_user.member?
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
end
