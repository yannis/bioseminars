App.CalendarView = Ember.View.extend
  templateName: 'calendar/calendar'

  fullCalendarRendered: false

  year: ->
    @controller.get('year')

  month: ->
    @controller.get('month')

  day: ->
    @controller.get('day')

  type: ->
    @controller.get('type')

  store: ->
    @controller.get("store")

  defaultView: ->
    if @type() == 'day'
      'agendaDay'
    else if @type() == 'week'
      'agendaWeek'
    else
      'month'

  didInsertElement: ->
    this._super()
    @renderCalendar()

  renderCalendar: ->
    self = @
    $('#calendar').fullCalendar
      defaultView: @defaultView()
      year: @year()
      month: parseInt(@month())-1
      day: @day()
      axisFormat: 'H:mm'
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month,agendaWeek,agendaDay'
      editable: true
      firstDay: 1
      timeFormat: 'H:mm'
      disableDragging: true
      disableResizing: true
      weekMode: 'fluid'

      loading: (bool)=>
        App.set("loading", bool)

      events: (start, end, callback) =>
        @store().find("seminar",
            after: moment(start).format("YYYYMMDD")
            before: moment(end).format("YYYYMMDD")
          ).then (data) =>
            @controller.set "seminars", data
            events = data.get("content")
            callback(events)

      eventDataTransform: (seminar) ->

        event =
          id: seminar.get('id')
          id: seminar.get('id')
          date_time_location_and_category: seminar.get("date_time_location_and_category")
          title: "#{seminar.get('acronyms')}\n#{seminar.get("speakerName")}"
          start: seminar.get('startAt')
          end: if seminar.get('endAt') then seminar.get('endAt') else null
          allDay: seminar.get('all_day')
          color: seminar.get('color')
          show: seminar.get('show')
          className: "fc-event-#{seminar.get('id')} #{if seminar.get('show') then '' else 'hidden'}"
          seminar: seminar
        return event


      eventClick: (data, event, view) =>
        @controller.transitionToRoute "calendar_seminar", data.id
        false

      eventAfterAllRender: (view)=>
        @set "fullCalendarRendered", true

      viewDisplay: (view) =>
        $('.calendar-loader').hide()

        vyear = moment(view.start).format("YYYY")
        vmonth = moment(view.start).format("MM")
        vday = moment(view.start).format("DD")
        vtype = view.name

        ntype =
          if vtype == 'agendaDay'
            'day'
          else if vtype == 'agendaWeek'
            'week'
          else
            'month'

        if vyear != @year() || vmonth != @month() || vtype != @defaultView()
          @controller.transitionToRoute "calendar", {year: vyear, month: vmonth, day: vday, type: ntype}

      eventAfterRender: (event, element, view) =>
        # debugger
        seminar = event.seminar
        seminar.addObserver 'show', ->
          if seminar.get('show')
            $(element).removeClass('hidden')
          else
            $(element).addClass('hidden')

      dayRender: (date, cell) =>
        if App.Session.authUser
          $link = $("<a class='calendar-new_seminar_link' href='#' >(+)</a>")
          $link.attr "title", "Add event to this day"
          $link.on "click", (e)=>
            e.preventDefault()
            e.stopPropagation()

            year = moment(date).format("YYYY")
            month = moment(date).format("MM")
            day = moment(date).format("DD")

            @controller.transitionToRoute "seminars.new_with_date", {year: year, month: month, day: day}
          cell.find(">div").prepend $link

  reRenderCalendar: (->
    if App.Session.authUser
      $('#calendar').fullCalendar("destroy")
      @renderCalendar()
  ).observes('App.Session.authUser')
