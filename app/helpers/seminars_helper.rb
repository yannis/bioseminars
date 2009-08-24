module SeminarsHelper
  def render_calendar_cell(d)
    day_number = "<span class='day_number'>#{d.mday}</span>"
    if @days_with_seminars.include?(d)          # (days that are in the array listOfSpecialDays) one CSS class,
      sem = [day_number]
      sem << "<ul>"
      for s in Seminar.of_day(d)
        sem << '<li>'
        sem << link_to( s.title, seminar_path(s))
        sem << '</li>'
      end
      sem << "</ul>"
      [sem.join, {:class => "specialDay"}]      # "specialDay", and gives the rest of the days another CSS class,
    else                                      # "normalDay". You can also use this highlight today differently
      [day_number, {:class => "normalDay"}]       # from the rest of the days, etc.
    end
  end
end
