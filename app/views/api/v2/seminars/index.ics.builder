cal = Icalendar::Calendar.new do |ical|
  # ical.add_x_property 'X-WR-CALNAME',@room.name
  seminars.each do |seminar|
    seminar.alarm = params['alarm']
    ical.event do |event|
      event.summary = "#{seminar.categories.map(&:acronym).compact.join(', ')} – #{seminar.title}"
      event.dtstart = seminar.start_at
      event.dtend = seminar.end_at
      event.location = seminar.location.name_and_building unless seminar.location.blank?
      description = []
      description << seminar.speaker_name_and_affiliation
      description << "Hosted by "+seminar.hosts.map(&:name).join(', ')
      event.description = description.join(' | ')
      event.url = ember_url(seminar)
      if seminar.alarm.present? && seminar.alarm.to_i >= 0
        event.alarm do
          trigger "-PT#{seminar.alarm}M"
          description "#{seminar.categories.map(&:acronym).compact.join(', ')} – #{seminar.title}"
          action 'DISPLAY'
        end
      end
    end
  end
end
cal.to_ical
