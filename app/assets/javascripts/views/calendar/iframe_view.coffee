App.IframeView = Ember.View.extend
  templateName: 'calendar/iframe'
  # layout: Ember.Handlebars.compile('<div class="layoutClass">{{yield}}</div>')
  layoutName: "iframe"

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

            if vyear != year || vmonth != month  || vtype != defaultView
              controller.transitionToRoute "calendar", {year: vyear, month: vmonth, day: vday, type: ntype}
              self.rerender()
            $('.calendar-loader').hide()

          eventAfterRender: (event, element, view) ->
            seminar = event.emSelf
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
