App.CalendarView = Ember.View.extend

  needs: ['seminars']

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
        seminar.get("forFullCalendar")


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

      updateEvent: (event) ->

      eventAfterRender: (event, element, view) =>
        seminar = event.seminar
        seminar.addObserver 'show', ->
          if seminar.get('show')
            $(element).removeClass('hidden')
          else
            $(element).addClass('hidden')
        seminar.one 'didUpdate', ->
          $('#calendar').fullCalendar('refetchEvents')
          window.location = "/"+window.location.hash.replace("/seminar/#{event.id}", "").replace("/seminars/#{event.id}", "")
        seminar.one 'didDelete', ->
          $('#calendar').fullCalendar('refetchEvents')

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

  reRenderEvents: (->
    $('#calendar').fullCalendar("refetchEvents")
  ).observes('controllers.seminars.model')
