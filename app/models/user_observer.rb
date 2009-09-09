class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
    UserMailer.deliver_reset_notification(user) if user.recently_forgot_password? || user.recently_reset_password?
  end
end
