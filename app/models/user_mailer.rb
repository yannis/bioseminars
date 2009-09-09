class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Your account has been created!'
    @body[:url]  = "http://#{HOST}/login"
  end
  
  # def activation(user)
  #   setup_email(user)
  #   @subject    += 'Your account has been activated!'
  #   @body[:url]  = "#{HOST}/"
  # end
  
  def reset_notification(user)
    setup_email(user)
    @subject    += 'Forgotten password? - Reset it!'
    @body[:url]  = "http://#{HOST}/reset_password/#{user.reset_code}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "yannis.jaquet@unige.ch"
      @subject     = "bioSeminars: "
      @sent_on     = Time.now
      @body[:user] = user
    end
end