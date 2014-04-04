App.CalendarView = Ember.View.extend
  templateName: 'calendar/calendar'
  getSeminars: ->
    @get('controller.seminarsAsJSON')

  didInsertElement: ->
    this._super()
    self = @
    controller = @get('controller')
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

    # debugger
    @get('controller.seminars').then(
      ((data) ->
        datajson = data.map((s) -> s.get("asJSON"))
        $('#calendar').fullCalendar
          defaultView: defaultView
          year: controller.get('year')
          month: parseInt(controller.get('month'))-1
          day: controller.get('day')
          axisFormat: 'H:mm'
          # defaultEventMinutes: 60
          header:
            left: 'prev,next today'
            center: 'title'
            right: 'month,agendaWeek,agendaDay'
          editable: true
          firstDay: 1
          timeFormat: 'H:mm'
          disableDragging: true
          disableResizing: true
          events: datajson
          eventClick: (data, event, view) ->
            controller.transitionToRoute "calendar_seminar", data.emSelf
            false

          dayClick: (date, allDay, jsEvent, view) ->
            vyear = moment(date).format("YYYY")
            vmonth = moment(date).format("MM")
            vday = moment(date).format("DD")

            if allDay && view.name == 'month'
              controller.transitionToRoute "calendar", {year: vyear, month: vmonth, day: vday, type: 'day'}
              self.rerender()

          viewDisplay: (view) ->
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

            # console.log "vyear", vyear
            # console.log "year", year
            # console.log "vmonth", vmonth
            # console.log "month", month
            # console.log "vday", vday
            # console.log "day", day
            # console.log "vtype", vtype
            # console.log "defaultView", defaultView

            if vyear != year || vmonth != month  || vtype != defaultView
              controller.transitionToRoute "calendar", {year: vyear, month: vmonth, day: vday, type: ntype}
              self.rerender()
            $('.calendar-loader').hide()

          eventAfterRender: (event, element, view) ->
            seminar = event.emSelf
            # console.log "eventAfterRender seminar", seminar
            seminar.addObserver 'show', ->
              if seminar.get('show')
                $(element).removeClass('hidden')
              else
                $(element).addClass('hidden')
      ),
      (->
        console.log "niet no seminars loaded"
      )
    )
