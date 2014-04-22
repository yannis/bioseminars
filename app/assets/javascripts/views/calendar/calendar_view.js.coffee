App.CalendarView = Ember.View.extend
  templateName: 'calendar/calendar'

  didInsertElement: ->
    this._super()
    self = @
    controller = @get('controller')
    store = controller.get("store")
    type = controller.get('type')
    defaultView =
      if type == 'day'
        'agendaDay'
      else if type == 'week'
        'agendaWeek'
      else
        'month'
    year = controller.get('year')
    month = controller.get('month')
    day = controller.get('day')

    $('#calendar').fullCalendar
      defaultView: defaultView
      year: controller.get('year')
      month: parseInt(controller.get('month'))-1
      day: controller.get('day')
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
      loading: (bool)->
        App.set("loading", bool)
      events: (start, end, callback) ->
        store.find("seminar",
            after: moment(start).format("YYYYMMDD")
            before: moment(end).format("YYYYMMDD")
          ).then (data) =>
            controller.set "seminars", data
            events = data.get("content").map((s) -> s.get("asJSON"))
            callback(events)

      eventClick: (data, event, view) ->
        controller.transitionToRoute "calendar_seminar", data.id
        false

      dayClick: (date, allDay, jsEvent, view) ->
        if App.Session.authUser
          year = moment(date).format("YYYY")
          month = moment(date).format("MM")
          day = moment(date).format("DD")
          controller.transitionToRoute "seminars.new_with_date", {year: year, month: month, day: day}

      viewDisplay: (view) =>
        calendar = @
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

        if vyear != year || vmonth != month || vtype != defaultView
          controller.transitionToRoute "calendar", {year: vyear, month: vmonth, day: vday, type: ntype}


      eventAfterRender: (event, element, view) ->
        seminar = event.emSelf
        seminar.addObserver 'show', ->
          if seminar.get('show')
            $(element).removeClass('hidden')
          else
            $(element).addClass('hidden')

