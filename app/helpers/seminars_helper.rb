module SeminarsHelper
  def render_calendar_cell(d)
    day_number = "<span class='day_info'>"
    day_number += "<span class='month_name'>#{Date::ABBR_MONTHNAMES[d.mon]}</span>" unless d == Date.current or d.month == Date.current.month
    day_number += " <span class='day_today'>Today</span>" if d == Date.current
    day_number += " <span class='day_number'>#{d.mday}</span>"
    day_number += "</span>"
    if @days_with_seminars.include?(d)          # (days that are in the array listOfSpecialDays) one CSS class,
      sem = [day_number]
      sem << "<ul id='seminars_#{d.to_s}'>"
      for s in @seminars.of_day(d)
        sem << render('seminars/seminar_for_calendar', :seminar => s)
      end
      sem << "</ul>"
      [sem.join, {:class => "specialDay"}]      # "specialDay", and gives the rest of the days another CSS class
    else                                      # "normalDay". You can also use this highlight today differently
      [day_number, {:class => "normalDay"}]       # from the rest of the days, etc.
    end
  end
  
  def add_object_link(name, form, object, partial, where)
    html = render(partial, :form => form, :object => object)
    link_to_function name, %{
      var new_object_id = new Date().getTime() ;
      var html = jQuery(#{js html}.replace(/index_to_replace_with_js/g, new_object_id)).hide();
      html.appendTo(jQuery("#{where}")).slideDown('slow');
    }
  end
  
  def link_to_insert(model, text=nil)
    html = render(model)
    link_to_function "Add another #{text.nil? ? model.class.to_s.downcase : text}", %{
      var new_object_id = new Date().getTime();
      var new_element = '#{escape_javascript(html).html_safe}'.replace(/index_to_replace_with_js/g, new_object_id);
      $(new_element).insertBefore($(this));
      insert_loaders();
    }, :class => 'add_link', :id => "add_a_#{model.class.to_s.downcase}"
  end
  
  
  def add_doc_or_pic_link
    html = render('seminars/doc_or_pic')
    link_to_function '(+)', %{
      var new_object_id = new Date().getTime();
      var new_element = '#{escape_javascript(html).html_safe}'.replace(/index_to_replace_with_js/g, new_object_id);
      $('#document_or_picture').append($(new_element));}
  end
  
    # 
    # var new_object_id = new Date().getTime();
    # 
    # Element.insert('document_or_picture', {bottom: '#{escape_javascript(html)}'})

  def js(data)
    if data.respond_to? :to_json
      data.to_json
    else
      data.inspect.to_json
    end
  end
end