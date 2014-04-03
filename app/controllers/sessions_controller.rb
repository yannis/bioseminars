class SessionsController < ApplicationController

  skip_before_filter :authenticate_user_from_token!, :authorize

  def create
    user = User.find_for_database_authentication(email: params[:session][:email])

    if user && user.valid_password?(params[:session][:password])
      user.update_attributes authentication_token: Devise.friendly_token
      sign_in user
      render json: {
        session: { user_id: user.id, email: user.email, authentication_token: user.authentication_token }
      }, status: :created
    else
      render json: {errors: "invalid email or password"}, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.blank?
      render json: "no user signed in", status: :accepted
    elsif current_user.present?
      current_user.update_attributes authentication_token: nil
      sign_out :user
      render json: {}, status: :accepted
    else
      render json: {
        errors: "unable to sign out user"
      }, status: :unprocessable_entity
    end
  end
end
