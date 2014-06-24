class SessionsController < Devise::SessionsController

  skip_before_filter :authenticate_user_from_token!, only: :create

  def create
    user = User.find_for_database_authentication(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      user.update_attributes authentication_token: Devise.friendly_token
      sign_in user

      data = {
        user_token: user.authentication_token, # must be prefixed auth: to work with ember-simple-auth-devise
        user_email: user.email, # must be prefixed auth: to work with ember-simple-auth-devise
        user_id: user.id
      }
      render json: data, status: 201
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
