module SeminarsHelper
  def render_calendar_cell(d)
    day_number = "<span class='day_number'>#{d.mday}</span>"
    if @days_with_seminars.include?(d)          # (days that are in the array listOfSpecialDays) one CSS class,
      sem = [day_number]
      sem << "<ul id='seminars_#{d.to_s}'>"
      for s in @seminars.of_day(d)
        sem << render(:partial => 'seminars/seminar_for_calendar', :locals => {:seminar => s})
      end
      sem << "</ul>"
      [sem.join, {:class => "specialDay"}]      # "specialDay", and gives the rest of the days another CSS class,
    else                                      # "normalDay". You can also use this highlight today differently
      [day_number, {:class => "normalDay"}]       # from the rest of the days, etc.
    end
  end
  
  def add_object_link(name, form, object, partial, where)
    html = render(:partial => partial, :locals => { :form => form}, :object => object)
    link_to_function name, %{
      var new_object_id = new Date().getTime() ;
      var html = jQuery(#{js html}.replace(/index_to_replace_with_js/g, new_object_id)).hide();
      html.appendTo(jQuery("#{where}")).slideDown('slow');
    }
  end

  def js(data)
    if data.respond_to? :to_json
      data.to_json
    else
      data.inspect.to_json
    end
  end
end