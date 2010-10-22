class UserMailer < ActionMailer::Base
  
  default :from => "noreply_bioseminars@unige.ch"
  
  def signup_notification(user)
    @url  = new_user_session_url
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "bioSeminars: Your account has been created!", :reply_to => ["Yannis Jaquet <yannis.jaquet@unige.ch>"]) do |format|
      format.text
    end
  end
end