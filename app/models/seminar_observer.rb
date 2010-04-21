class SeminarObserver < ActiveRecord::Observer
  # def after_create(user)
  #   UserMailer.deliver_signup_notification(user)
  # end

  def before_destroy(seminar)
    for host in seminar.hosts
      Host.destroy(host) if host.seminars == [seminar]
    end
  end
end