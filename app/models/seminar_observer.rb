class SeminarObserver < ActiveRecord::Observer

  def before_destroy(seminar)
    for host in seminar.hosts
      Host.destroy(host) if host.seminars == [seminar]
    end
  end
end